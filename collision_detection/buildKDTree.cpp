/**
 * 
 */

#include "mex.h"

inline void median(double* array, int length, int& medianIdx);

void mexFunction(int nlhs, mxArray* plhs[], 
                 int nrhs, const mxArray* prhs[]) {
    if(nrhs != 2)
        mexErrMsgIdAndTxt( "MATLAB:buildKDTree:invalidNumInputs",
                "Exactly two input (centerPointOfFace, normalVectors) required.");

    double *centerPoints;
    centerPoints = mxGetPr(prhs[0]); /* Pointer to first input matrix. */
    int pointsNum;
    pointsNum = mxGetN(prhs[0]);

    double *nVectors;
    nVectors = mxGetPr(prhs[1]);


}

inline void median(double* array, int length, int& medianIdx) {
    
}


