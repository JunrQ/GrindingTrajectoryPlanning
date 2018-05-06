//
// Created by Junr on 05/05/2018.
//

#include "myTsp.hpp"

void mexFunction(int nlhs, mxArray* plhsp[], 
                 int nrhs, const mxArray* prhs[]) {
    if(nrhs != 1)
        mexErrMsgIdAndTxt( "MATLAB:convec:invalidNumInputs",
                "Exactly one input required.");
    if(nlhs != 1)
        mexErrMsgIdAndTxt( "MATLAB:convec:invalidNumOutputs",
                "Exactly one output required.");
    if( mxGetN(prhs[0]) != 3 )
        mexErrMsgIdAndTxt( "MATLAB:convec:inputsNot3Features",
                "Input should have 3 columns.");

    /* Get the input to double[] */
    double *input;
    size_t m;
    input = mxGetPr(prhs[0]); /* Pointer to first input matrix. */
    m = mxGetM(prhs[0]); /* Number of rows. */

    // point to first output
    plhs[0] = mxCreateDoubleMatrix((mwSize)m, (mwSize)3, mxREAL);
    z = mxGetPr(plhs[0]); // get the pointer

    // call the C/C++ subroutine.
    

}

void myTspSolver_GA(double* input, double* output, int num) {

}