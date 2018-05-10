#include "mex.h"

void mexFunction(int nlhs, mxArray* plhs[], 
                 int nrhs, const mxArray* prhs[]) {
    double* i;
    i = mxGetPr(prhs[0]);
    double j=i[0];
    mexPrintf("%f\n", i[0]);
    mexPrintf("%f\n", i[1]);
    mexPrintf("%f\n", i[2]);
    mexPrintf("%f\n", i[3]);
}