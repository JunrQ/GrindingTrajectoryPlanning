//
// Created by Junr on 05/07/2018.
//

#include "mex.h"
#include <vector>
#include <math.h>

using std::vector;

void _faceToPoints(double *threeFacePoints, double gap, vector<double>& pointsCloud);

inline double _norm2(double x1, double y1, double z1, double x2, double y2, double z2) {
    return sqrt((y2-y1)*(y2-y1)+(x2-x1)*(x2-x1)+(z2-z1)*(z2-z1));
}

/**
 * @brief Demanded by mex scripts.
 * 
 * @author JunrZhou
 * @date 2018-5-7
 */
void mexFunction(int nlhs, mxArray* plhs[], 
                 int nrhs, const mxArray* prhs[]) {
    // input check
    if(nrhs != 5)
        mexErrMsgIdAndTxt( "MATLAB:generatePointsCloud:invalidNumInputs",
                "Exactly four input (faces_idx, v, f, n, gap) required.");
    if(nlhs != 2)
        mexErrMsgIdAndTxt( "MATLAB:generatePointsCloud:invalidNumOutputs",
                "Exactly two (pointsCloud, pointsCloudFaceIdx) output required.");
    
    size_t m;

    /* Get the input to double[]. */
    double *faceIdx;
    faceIdx = mxGetPr(prhs[0]); /* Pointer to first input matrix. */
    int face_num;
    face_num = mxGetN(prhs[0]);
    
    double *v;
    v = mxGetPr(prhs[1]);
    int vertices = mxGetM(prhs[1]);
    double *f;
    f = mxGetPr(prhs[2]);
    int tot_face_num;
    tot_face_num = mxGetM(prhs[2]); /* Number of rows. */
    // mexPrintf("%d\n", tot_face_num);
    double *n;
    n = mxGetPr(prhs[3]);
    double *gapPointer;
    gapPointer = mxGetPr(prhs[4]);
    double gap = *gapPointer;
    // mexPrintf("%f\n", gap);

    // call the C/C++ subroutine.
    int pointNum = 0;
    int faceIdxInfo[face_num];
    vector<vector<double> > pointsCloudIdx;
    for (int i=0; i<face_num; i++) {
        faceIdxInfo[i] = faceIdx[i];
        vector<double> tmpPointsCloud;
        // mexPrintf("%d\n", (int)(faceIdx[i]));
        int p1 = f[(int)(faceIdx[i])-1] - 1;
        int p2 = f[(int)(faceIdx[i])+tot_face_num-1] - 1;
        int p3 = f[(int)(faceIdx[i])+2*tot_face_num-1] - 1;
        // mexPrintf("%d %d %d\n", p1, p2, p3);
        // mexPrintf("%f, %f, %f\n%f, %f, %f\n%f, %f, %f\n", 
        //                              v[p1], v[p1+vertices], v[p1+2*vertices],
        //                              v[p2], v[p2+vertices], v[p2+2*vertices],
        //                              v[p3], v[p3+vertices], v[p3+2*vertices]);
        double threeFacePoints[9] = {v[p1], v[p1+vertices], v[p1+2*vertices],
                                     v[p2], v[p2+vertices], v[p2+2*vertices],
                                     v[p3], v[p3+vertices], v[p3+2*vertices]};
        _faceToPoints(threeFacePoints, gap, tmpPointsCloud);
        pointNum += (tmpPointsCloud.size() / 3);
        pointsCloudIdx.push_back(tmpPointsCloud);
    }

    /* Get the output to double[]. */
    double* pointsCloud;
    plhs[0] = mxCreateDoubleMatrix((mwSize)pointNum, (mwSize)3, mxREAL);
    pointsCloud = mxGetPr(plhs[0]); // get the pointer

    double* pointsCloudFaceIdx;
    plhs[1] = mxCreateDoubleMatrix((mwSize)pointNum, (mwSize)1, mxREAL);
    pointsCloudFaceIdx = mxGetPr(plhs[1]);

    // mexPrintf("%d\n", pointNum);

    vector<double> tmpPointsCloud;
    int curCount = 0;
    for (int i=0; i<face_num; i++) {
        tmpPointsCloud = pointsCloudIdx[i];
        for (int j=0; j<tmpPointsCloud.size(); j++) {
            pointsCloud[curCount] = tmpPointsCloud[j++];
            pointsCloud[curCount+pointNum] = tmpPointsCloud[j++];
            pointsCloud[curCount+2*pointNum] = tmpPointsCloud[j];
            pointsCloudFaceIdx[curCount] = faceIdxInfo[i];
            curCount++;
        }
    }
    return;
}

/**
 * @brief Given three points of a face, return points on the surface of the face.
 * 
 * Make sure length of threeFacePoint is 9.
 * 
 * @params threeFacePoints, six numbers
 * @params gap
 * @params pointsCloud
 * @author JunrZhou
 * @date 2018-5-8
 */
void _faceToPoints(double *threeFacePoints, double gap, vector<double>& pointsCloud) {
    /* Find the longest line. */
    double length[3];
    length[0] = _norm2(threeFacePoints[0],
                       threeFacePoints[1],
                       threeFacePoints[2],
                       threeFacePoints[3],
                       threeFacePoints[4],
                       threeFacePoints[5]);
    length[1] = _norm2(threeFacePoints[3],
                       threeFacePoints[4],
                       threeFacePoints[5],
                       threeFacePoints[6],
                       threeFacePoints[7],
                       threeFacePoints[8]);
    length[2] = _norm2(threeFacePoints[6],
                       threeFacePoints[7],
                       threeFacePoints[8],
                       threeFacePoints[0],
                       threeFacePoints[1],
                       threeFacePoints[2]);
    // mexPrintf("%f %f %f\n", length[0], length[1], length[2]);
    int maxIdx = 0;
    double maxVal = 0;
    for (int i=0; i<3; i++) {
        if (length[i] > maxVal) {
            maxVal = length[i];
            maxIdx = i;
        }
    }
    int peakPointIdx0 = (maxIdx % 3) * 3;
    int peakPointIdx1 = ((maxIdx + 1) % 3) * 3;
    int thirdPointIdx = 9 - peakPointIdx0 - peakPointIdx1;

    /* Cut apart the longest line. */
    int fragmentNum = (int)((maxVal + gap - gap/10000) / gap); // similar to ceil

    double peakPointX = threeFacePoints[peakPointIdx0];
    double peakPointY = threeFacePoints[peakPointIdx0 + 1];
    double peakPointZ = threeFacePoints[peakPointIdx0 + 2];
    double peakDeltaX = (threeFacePoints[peakPointIdx1] - peakPointX) / maxVal * gap;
    double peakDeltaY = (threeFacePoints[peakPointIdx1 + 1] - peakPointY) / maxVal * gap;
    double peakDeltaZ = (threeFacePoints[peakPointIdx1 + 2] - peakPointZ) / maxVal * gap;

    // mexPrintf("peak points:\n%f, %f, %f\n", 
    //             peakPointX, peakPointY, peakPointZ);

    
    double thirdPointX = threeFacePoints[thirdPointIdx];
    double thirdPointY = threeFacePoints[thirdPointIdx + 1];
    double thirdPointZ = threeFacePoints[thirdPointIdx + 2];
    double thirdLength = _norm2(thirdPointX, thirdPointY, thirdPointZ,
                                threeFacePoints[peakPointIdx1],
                                threeFacePoints[peakPointIdx1+1],
                                threeFacePoints[peakPointIdx1+2]);
    double thirdGap = gap / maxVal * thirdLength;
    double thirdDeltaX = (threeFacePoints[peakPointIdx1] - thirdPointX) / thirdLength * thirdGap;
    double thirdDeltaY = (threeFacePoints[peakPointIdx1 + 1] - thirdPointY) / thirdLength * thirdGap;
    double thirdDeltaZ = (threeFacePoints[peakPointIdx1 + 2] - thirdPointZ) / thirdLength * thirdGap;

    for(int i=0; i<fragmentNum-1; i++) {
        double startPointX = peakPointX + i * peakDeltaX;
        double startPointY = peakPointY + i * peakDeltaY;
        double startPointZ = peakPointZ + i * peakDeltaZ;

        double endPointX = thirdPointX + i * thirdDeltaX;
        double endPointY = thirdPointY + i * thirdDeltaY;
        double endPointZ = thirdPointZ + i * thirdDeltaZ;

        // mexPrintf("start:\n%f, %f, %f\nend:\n%f, %f, %f\n", 
        //         startPointX, startPointY, startPointZ, endPointX, endPointY, endPointZ);

        double tmpLength = _norm2(startPointX, startPointY, startPointZ,
                                  endPointX, endPointY, endPointZ);
        
        double tmpDeltaX = (endPointX - startPointX) / tmpLength * gap;
        double tmpDeltaY = (endPointY - startPointY) / tmpLength * gap;
        double tmpDeltaZ = (endPointZ - startPointZ) / tmpLength * gap;

        double tmpPointsNum = (int)((tmpLength + gap - gap/10000) / gap);

        for(int j=0; j<(tmpPointsNum-1); j++) {
            pointsCloud.push_back(startPointX + j*tmpDeltaX);
            pointsCloud.push_back(startPointY + j*tmpDeltaY);
            pointsCloud.push_back(startPointZ + j*tmpDeltaZ);
        }

        pointsCloud.push_back(endPointX);
        pointsCloud.push_back(endPointY);
        pointsCloud.push_back(endPointZ);
    }
    pointsCloud.push_back(threeFacePoints[peakPointIdx1]);
    pointsCloud.push_back(threeFacePoints[peakPointIdx1+1]);
    pointsCloud.push_back(threeFacePoints[peakPointIdx1+2]);
}