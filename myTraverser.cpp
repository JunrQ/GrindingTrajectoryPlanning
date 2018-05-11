//
// Created by Junr on 05/05/2018.
//

#include "mex.h"
#include <math.h>
#include <float.h>
#include <vector>

inline bool checkDoubleEqual(const double x, const double y) {
    if(x > y)
        return (x-y)<1e-5;
    else
        return (y-x)<1e-5;
}

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
    int pointsNum;
    pointsCloud = mxGetPr(prhs[0]); /* Pointer to first input matrix. */
    pointsNum = mxGetM(prhs[0]); /* Number of rows. */

    double *pointsCloudIdx;
    if( mxGetM(prhs[1]) != pointsNum )
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
    double* orderedPointsCloud = new double[pointsNum * 3];
    double* orderedPointsCloudIdx = new double[pointsNum];

    // call the C/C++ subroutine.
    switch(method) {
        case 0: {
            int* visited = new int[pointsNum]();
            // mexPrintf("3\n");
            mySolverGreedy(pointsCloud, pointsCloudIdx,
                           orderedPointsCloud, orderedPointsCloudIdx,
                           distMat,
                           pointsNum,
                           visited);
            delete [] visited;
            break;
        }
    }
    // mexPrintf("1: %f\n", orderedPointsCloudIdx[0]);
    
    /* Removal of repetition. */
    std::vector<double> vecPointsCloud;
    std::vector<double> vecPointsCloudIdx;
    double lastX, lastY, lastZ, curX, curY, curZ;
    lastX = orderedPointsCloud[0];
    lastY = orderedPointsCloud[0 + pointsNum];
    lastZ = orderedPointsCloud[0 + 2*pointsNum];
    vecPointsCloud.push_back(lastX);
    vecPointsCloud.push_back(lastY);
    vecPointsCloud.push_back(lastZ);
    vecPointsCloudIdx.push_back(orderedPointsCloudIdx[0]);
    for(int i=1; i<pointsNum; i++) {
        curX = orderedPointsCloud[i];
        curY = orderedPointsCloud[i + pointsNum];
        curZ = orderedPointsCloud[i + 2*pointsNum];
        if(checkDoubleEqual(curX, lastX) && 
           checkDoubleEqual(curY, lastY) && 
           checkDoubleEqual(curZ, lastZ))
           {continue;}
        vecPointsCloud.push_back(curX);
        vecPointsCloud.push_back(curY);
        vecPointsCloud.push_back(curZ);
        vecPointsCloudIdx.push_back(orderedPointsCloudIdx[i]);
        lastX = curX;
        lastY = curY;
        lastZ = curZ;
    }

    /* Return. */
    int returnLength = vecPointsCloudIdx.size();
    double* rOrederedPointsCloud;
    plhs[0] = mxCreateDoubleMatrix((mwSize)returnLength, (mwSize)3, mxREAL);
    rOrederedPointsCloud = mxGetPr(plhs[0]); // get the pointer
    double* rOrederedPointsCloudIdx;
    plhs[1] = mxCreateDoubleMatrix((mwSize)returnLength, (mwSize)1, mxREAL);
    rOrederedPointsCloudIdx = mxGetPr(plhs[1]); // get the pointer

    for (int i=0; i<returnLength; i++) {
        rOrederedPointsCloud[i] = vecPointsCloud[3*i];
        rOrederedPointsCloud[i + returnLength] = vecPointsCloud[3*i + 1];
        rOrederedPointsCloud[i + 2*returnLength] = vecPointsCloud[3*i + 2];
        rOrederedPointsCloudIdx[i] = vecPointsCloudIdx[i];
    }

    delete [] orderedPointsCloud;
    delete [] orderedPointsCloudIdx;
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
    visited[minIdx] = 1;

    double minVal = -1;
    for(int i=1; i<length; i++) {
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

        vecMin(tmpDist, length-i-1, minIdx, minVal);
        minIdx = tmpPointsIdx[minIdx];
        visited[minIdx] = 1;
        // mexPrintf("%d: %d\n", i, minIdx);

        orderedPointsCloud[i] = pointsCloud[minIdx];
        orderedPointsCloud[i+length] = pointsCloud[minIdx+length];
        orderedPointsCloud[i+2*length] = pointsCloud[minIdx+2*length];
        orderedPointsCloudIdx[i] = pointsCloudIdx[minIdx];
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