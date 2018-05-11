//
// Created by Junr on 05/05/2018.
//

#include "mex.h"
#include <math.h>
#include <float.h>

/**
 * @brief Get the distance matrix of points.
 * 
 * @author JunrZhou
 * @date 2018-5-11
 */
void distanceMatrix(const double* points, double* distM, const int pointsNum);

/**
 * @brief Traverse of graphs problem solver, use greedy algorithm.
 * 
 * Each matrix in input represent a vertex in graph. A vertex is connected
 * to all other vectices.
 * 
 * @author JunrZhou
 * @date 2018-5-7
 * 
 * TODO: There are many places you can do to make it faster.
 */
void mySolverGreedy(const double* pointsCloud, const double* pointsCloudIdx,
                    double* orderedPointsCloud, double* orderedPointsCloudIdx,
                    const double* distanceMatrix,
                    const int length,
                    int* visited);

/**
 * @brief Traverse of graphs problem solver, use GA(genetic algorithm).
 * 
 * Each matrix in input represent a vertex in graph. A vertex is connected
 * to all other vectices.
 * 
 * @author JunrZhou
 * @date 2018-5-7
 */
void mySolverGA(double* pointsCloud, double* pointsCloudIdx,
                double* orderedPointsCloud, double* orderedPointsCloudIdx,
                int length);

inline double _norm2(double x1, double y1, double z1, double x2, double y2, double z2) {
    return sqrt((y2-y1)*(y2-y1)+(x2-x1)*(x2-x1)+(z2-z1)*(z2-z1));
}

/**
 * @brief Get the min value and index of an array.
 */
inline void vecMin(const double* vec, const int l, int& minIdx, double& minVal) {
    double tmpMinVal = DBL_MAX;
    int tmpMinIdx = 0;
    for (int i=0; i<l; i++) {
        if (vec[i] < tmpMinVal) {
            tmpMinIdx = i;
            tmpMinVal = vec[i];
        }
    }
    minIdx = tmpMinIdx;
    minVal = tmpMinVal;
}

/**
 * @brief Demanded by mex scripts.
 * 
 * @author JunrZhou
 * @date 2018-5-7
 */
void mexFunction(int nlhs, mxArray* plhs[], 
                 int nrhs, const mxArray* prhs[]) {
    if(nrhs != 3)
        mexErrMsgIdAndTxt( "MATLAB:myTraverser:invalidNumInputs",
                "Exactly three (pointsCloud, pointsCloudIdx, method) input required.");
    if(nlhs != 2)
        mexErrMsgIdAndTxt( "MATLAB:myTraverser:invalidNumOutputs",
                "Exactly two (orderedPointsCloud, orderedPointsCloudIdx) output required.");

    if( mxGetN(prhs[0]) != 3 )
        mexErrMsgIdAndTxt( "MATLAB:convec:inputsNot3Features",
                "Input should have 3 columns for the fact they are in 3D space.");

    /* Get the input to double[] */
    double *pointsCloud;
    int pointsNum3, pointsNum;
    pointsCloud = mxGetPr(prhs[0]); /* Pointer to first input matrix. */
    pointsNum3 = mxGetM(prhs[0]); /* Number of rows. */
    pointsNum = pointsNum3 / 3;

    double *pointsCloudIdx;
    if( mxGetM(prhs[1]) != pointsNum3 )
        mexErrMsgIdAndTxt( "MATLAB:myTraverser:invalidInputsShape",
                "pointsCloudIdx should have same number of rows as pointsCloud");
    pointsCloudIdx = mxGetPr(prhs[1]);

    double *methodPtr;
    double methodDouble;
    methodPtr = mxGetPr(prhs[2]);
    methodDouble = *methodPtr;
    if(methodDouble > 0.1)
        mexErrMsgIdAndTxt( "MATLAB:myTraverser:invalidInputsValue",
                "Only support method:\n 0: greedy algorithm");
    int method = (int)(methodDouble + 0.001);

    /*[TODO] This takes more than two times more memory. Bad.*/
    double* distMat = new double[pointsNum*pointsNum]();
    distanceMatrix(pointsCloud, distMat, pointsNum);

    // point to first output
    double* orderedPointsCloud;
    plhs[0] = mxCreateDoubleMatrix((mwSize)pointsNum, (mwSize)3, mxREAL);
    orderedPointsCloud = mxGetPr(plhs[0]); // get the pointer

    double* orderedPointsCloudIdx;
    plhs[0] = mxCreateDoubleMatrix((mwSize)pointsNum, (mwSize)1, mxREAL);
    orderedPointsCloudIdx = mxGetPr(plhs[0]);

    // call the C/C++ subroutine.
    switch(method) {
        case 0: {
            int* visited = new int[pointsNum]();
            mySolverGreedy(pointsCloud, pointsCloudIdx,
                           orderedPointsCloud, orderedPointsCloudIdx,
                           distMat,
                           pointsNum,
                           visited);
            delete [] visited;
            break;
        }
    }
    
    delete [] distMat;
    return;
}

void mySolverGA(double* pointsCloud, double* pointsCloudIdx,
                double* orderedPointsCloud, double* orderedPointsCloudIdx,
                int length) {
    return;
}

void mySolverGreedy(const double* pointsCloud, const double* pointsCloudIdx,
                    double* orderedPointsCloud, double* orderedPointsCloudIdx,
                    const double* distanceMatrix,
                    const int length,
                    int* visited) {
    /* Initilization. */
    int minIdx = 0;
    orderedPointsCloud[minIdx] = pointsCloud[minIdx];
    orderedPointsCloud[minIdx+length] = pointsCloud[minIdx+length];
    orderedPointsCloud[minIdx+2*length] = pointsCloud[minIdx+2*length];
    orderedPointsCloudIdx[minIdx] = pointsCloudIdx[minIdx];

    double minVal = -1;
    for(int i=0; i<length; i++) {
        visited[minIdx] = 1;

        double tmpDist[length - i];
        int tmpPointsIdx[length - i];
        int tmpCount = 0;
        for (int j=0; j<length; j++) {
            if(visited[j] == 0) {
                tmpDist[tmpCount] = distanceMatrix[minIdx+j*length];
                tmpPointsIdx[tmpCount] = j;
                if(tmpCount == (length-i-1))break;
                tmpCount++;
            }
        }

        vecMin(tmpDist, length-i, minIdx, minVal);
        minIdx = tmpPointsIdx[minIdx];

        orderedPointsCloud[minIdx] = pointsCloud[minIdx];
        orderedPointsCloud[minIdx+length] = pointsCloud[minIdx+length];
        orderedPointsCloud[minIdx+2*length] = pointsCloud[minIdx+2*length];
        orderedPointsCloudIdx[minIdx] = pointsCloudIdx[minIdx];
    }
}

void distanceMatrix(const double* points, double* distM, const int pointsNum) {
    for (int r=0; r<pointsNum; r++) {
        // rows
        for (int c=r+1; c<pointsNum; c++) {
            double tmpL = _norm2(points[r], points[r+pointsNum], points[r+2*pointsNum],
                                 points[c], points[c+pointsNum], points[c+2*pointsNum]);
            distM[r + c*pointsNum] = tmpL;
            distM[c + r*pointsNum] = tmpL;
        }
    }
}