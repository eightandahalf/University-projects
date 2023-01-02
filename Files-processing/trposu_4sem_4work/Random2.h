#ifndef _RANDOM2_H
#define _RANDOM2_H

#include <random>

std::random_device dev2; // Will be used to obtain a seed for the random number engine
std::mt19937 rng2(dev2()); // Standard mersenne_twister_engine seeded with rd()

#endif // !_RANDOM2_H