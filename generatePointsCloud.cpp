//
// Created by Junr on 05/07/2018.
//

#include "mex.h"

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
    
    /* Get the input to double[]. */
    double *faceIdx;
    size_t face_num;
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
    
    

}

void faceToPoints()