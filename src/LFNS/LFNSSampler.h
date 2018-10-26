//
// Created by jan on 09/10/18.
//

#ifndef LFNS_LFNSSAMPLER_H
#define LFNS_LFNSSAMPLER_H


#include "LiveParticleSet.h"
#include "../sampler/Sampler.h"
#include "../sampler/DensityEstimation.h"
#include "LFNSSettings.h"

namespace lfns {
    class LFNSSampler {
    public:
        LFNSSampler(sampler::Sampler_ptr prior, sampler::DensityEstimation_ptr density_estimation);

        LFNSSampler(LFNSSettings &settings, base::RngPtr rng);

        virtual ~LFNSSampler();

        const std::vector<double> &samplePrior();

        const std::vector<double> &sampleConstrPrior();

        void updateLiveSamples(LiveParticleSet &live_points);

        void writeToStream(std::ostream &stream);

        sampler::DensityEstimation_ptr getDensityEstimation();

    private:
        base::RngPtr _rng;
        sampler::Sampler_ptr _prior;
        sampler::DensityEstimation_ptr _density_estimation;
        double _max_live_prior_value;
        base::UniformRealDistribution _dist;
        bool _uniform_prior;
        std::vector<int> _log_params;

        std::vector<double> &_scaleSample(std::vector<double> &sample);


    };
}


#endif //LFNS_LFNSSAMPLER_H
