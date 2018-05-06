//
// Created by Junr on 05/05/2018.
//

#ifndef FACE_TRAJ_MYTSP_HPP
#define FACE_TRAJ_MYTSP_HPP

#include "mex.h"

/**
 * @brief Demanded by mex scripts.
 */
void mexFunction(int nlhs, mxArray* plhsp[], int nrhs, const mxArray* prhs[]);

/**
 * @brief get distance matrix from [m, 3] matrix, which is m points in 3D space.
 * if we have 1K points, we need 1M * 4 for float, 1M * 8 for double storage space.
 * if 10K points, 400M for float, 800M for double. This is unacceptable.
 */
float* getDistanceMatrix(float* pointsCloud);

/**
 * @brief TSP problem solver, use GA(genetic algorithm).
 */
void myTspSolver_GA(double* input, double* output, int num);

#endif //FACE_TRAJ_MYTSP_HPP
