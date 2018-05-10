//
// Created by Junr on 05/07/2018.
//

#include "mex.h"
#include <vector>
#include <math>

using std::vector;

/**
 * @brief Demanded by mex scripts.
 * 
 * @author JunrZhou
 * @date 2018-5-7
 */
void mexFunction(int nlhs, mxArray* plhsp[], 
                 int nrhs, const mxArray* prhs[]) {
    // input check
    if(nrhs != 6)
        mexErrMsgIdAndTxt( "MATLAB:convec:invalidNumInputs",
                "Exactly four input (faces_idx, v, f, n, number_adjoint, adjoint_length) required.");
    if(nlhs != 3)
        mexErrMsgIdAndTxt( "MATLAB:convec:invalidNumOutputs",
                "Exactly three (pointsCloud, pointsCloudFaceIdx, pointsCloudAdjPointsIdx) output required.");
    
    size_t m;

    /* Get the input to double[]. */
    double *faceIdx;
    int face_num;
    faceIdx = mxGetPr(prhs[0]); /* Pointer to first input matrix. */
    face_num = mxGetM(prhs[0]); /* Number of rows. */

    double *v;
    v = mxGetPr(prhs[1]);
    double *f;
    f = mxGetPr(prhs[2]);
    double *n;
    n = mxGetPr(prhs[3]);
    int *number_adjoint;
    number_adjoint = mxGetPr(prhs[4]);
    double *adjoint_length;
    adjoint_length = mxGetPr(prhs[5]);

    /* Get the output to double[]. */
    double *pointsCloud;
    plhs[0] = mxCreateDoubleMatrix((mwSize)m, (mwSize)3, mxREAL);
    pointsCloud = mxGetPr(plhs[0]); // get the pointer

    double *pointsCloudFaceIdx;
    plhs[1] = mxCreateDoubleMatrix((mwSize)m, (mwSize)1, mxREAL);
    pointsCloudFaceIdx = mxGetPr(plhs[1]);

    double *pointsCloudFaceIdx;
    plhs[1] = mxCreateDoubleMatrix((mwSize)m, (mwSize)1, mxREAL);
    pointsCloudFaceIdx = mxGetPr(plhs[1]);

    // call the C/C++ subroutine.
    
    for ()


    

}

/**
 * @brief Given three points of a face, return points on the surface of the face.
 * 
 * Make sure length of threeFacePoint is 9.
 * 
 * @params threeFacePoints, six numbers
 * @params gap
 * @return 
 * @author JunrZhou
 * @date 2018-5-8
 */
double* _faceToPoints(double *threeFacePoints, double gap, vector<double>& pointsCloud) {
    /* Find the longest line. */
    double* length = new double[3];
    double length[0] = _norm2(threeFacePoints[0],
                       threeFacePoints[1],
                       threeFacePoints[2],
                       threeFacePoints[3],
                       threeFacePoints[4],
                       threeFacePoints[5]);
    double length[1] = _norm2(threeFacePoints[3],
                       threeFacePoints[4],
                       threeFacePoints[5],
                       threeFacePoints[6],
                       threeFacePoints[7],
                       threeFacePoints[8]);
    double length[2] = _norm2(threeFacePoints[6],
                       threeFacePoints[7],
                       threeFacePoints[8],
                       threeFacePoints[0],
                       threeFacePoints[1],
                       threeFacePoints[2]);
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
    int fragmentNum = (int)((maxVal + gap - gap/100000) / gap); // similar to ceil

    double peakPointX = threeFacePoints[peakPointIdx0];
    double peakPointY = threeFacePoints[peakPointIdx0 + 1];
    double peakPointZ = threeFacePoints[peakPointIdx0 + 2];
    double peakDeltaX = (threeFacePoints[peakPointIdx1] - peakPointX) / maxVal * gap;
    double peakDeltaY = (threeFacePoints[peakPointIdx1 + 1] - peakPointY) / maxVal * gap;
    double peakDeltaZ = (threeFacePoints[peakPointIdx1 + 2] - peakPointZ) / maxVal * gap;

    
    double thirdPointX = threeFacePoints[thirdPointIdx];
    double thirdPointY = threeFacePoints[thirdPointIdx + 1];
    double thirdPointZ = threeFacePoints[thirdPointIdx + 2];
    double thirdLength = _norm2(thirdPointX, thirdPointY, thirdPointZ,
                                threeFacePoints[peakPointIdx1],
                                threeFacePoints[peakPointIdx1+1],
                                threeFacePoints[peakPointIdx1+2]);
    double thirdDeltaX = (threeFacePoints[peakPointIdx1] - thirdPointX) / thirdLength * gap;
    double thirdDeltaY = (threeFacePoints[peakPointIdx1 + 1] - thirdPointY) / thirdLength * gap;
    double thirdDeltaZ = (threeFacePoints[peakPointIdx1 + 2] - thirdPointZ) / thirdLength * gap;

    double 
    for(int i=0; i<fragmentNum; i++) {
        int startPointX = peakPointX + i * peakDeltaX;
        int startPointY = peakPointY + i * peakDeltaY;
        int startPointZ = peakPointZ + i * peakDeltaZ;

        int endPointX = thirdPointX + i * thirdDeltaX;
        int endPointY = thirdPointY + i * thirdDeltaY;
        int endPointZ = thirdPointZ + i * thirdDeltaZ;

        double tmpLength = _norm2(startPointX, startPointY, startPointZ,
                                  endPointX, endPointY, endPointZ);
        
        double tmpDeltaX = (endPointX - startPointX) / tmpLength * gap;
        double tmpDeltaY = (endPointY - startPointY) / tmpLength * gap;
        double tmpDeltaZ = (endPointZ - startPointZ) / tmpLength * gap;

        double tmpPointsNum = (int)((tmpLength - gap + gap*99999/100000) / gap);

        for(int j=1; j<tmpPointsNum; j++) {
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

inline double _norm2(double x1, double y1, double z1, double x2, double y2, double z2) {
    return sqrt((y2-y1)*(y2-y1)+(x2-x1)*(x2-x1)+(z2-z1)*(z2-z1));
}