//
// Created by Junr on 05/05/2018.
//

#ifndef FACE_TRAJ_MYTSP_HPP
#define FACE_TRAJ_MYTSP_HPP

#include "mex.h"

/**
 * @brief Demanded by mex scripts.
 * 
 * @author JunrZhou
 * @date 2018-5-7
 */
void mexFunction(int nlhs, mxArray* plhsp[], int nrhs, const mxArray* prhs[]);

/**
 * @brief get distance matrix from [m, 3] matrix, which is m points in 3D space.
 * if we have 1K points, we need 1M * 4 for float, 1M * 8 for double storage space.
 * if 10K points, 400M for float, 800M for double. This is unacceptable.
 * 
 * @author JunrZhou
 * @date 2018-5-7
 */
float* getDistanceMatrix(float* pointsCloud);

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
void mySolver_GA(double* input, double* output, int num);

#endif //FACE_TRAJ_MYTSP_HPP
