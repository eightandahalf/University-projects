#ifndef _RANDOM3_H
#define _RANDOM3_H

#include <random>

std::random_device dev3; // Will be used to obtain a seed for the random number engine
std::mt19937 rng3(dev3()); // Standard mersenne_twister_engine seeded with rd()

#endif // !_RANDOM3_H