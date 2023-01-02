#ifndef _RANDOM_H
#define _RANDOM_H

#include <random>

std::random_device dev; // Will be used to obtain a seed for the random number engine
std::mt19937 rng(dev()); // Standard mersenne_twister_engine seeded with rd()

#endif // !_RANDOM_H