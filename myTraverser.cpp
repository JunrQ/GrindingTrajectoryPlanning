//
// Created by Junr on 05/05/2018.
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
    output = mxGetPr(plhs[0]); // get the pointer

    // call the C/C++ subroutine.
    mySolver_GA(input, output, (int)m);

}

/**
 * @brief Traverse of graphs problem solver, use GA(genetic algorithm).
 * 
 * Each matrix in input represent a vertex in graph. A vertex is connected
 * to all other vectices.
 * 
 * @param input     input matrix, [num, 3]
 * @param output    output matrix, [num, 3]
 * @param num       number of vertices
 * 
 * @author JunrZhou
 * @date 2018-5-7
 */
void mySolver_GA(double* input, double* output, int num) {

}