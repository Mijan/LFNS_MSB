//
// Created by jan on 09/10/18.
//

#ifndef LFNS_SAMPLERPARTICLES_H
#define LFNS_SAMPLERPARTICLES_H

#include <boost/serialization/base_object.hpp>
#include "Sampler.h"
#include "../base/EigenMatrices.h"

namespace sampler {
    class DensityEstimation : public Sampler {
    public:

        DensityEstimation(base::RngPtr rng, SamplerData data);

        virtual ~DensityEstimation() {}

        void updateDensitySamples(base::EiMatrix &samples);

        std::vector<double> &sample() override;

        virtual double getLogLikelihood(const std::vector<double> &sample);

        void setMean(base::EiVector mean);

        void setEV(base::EiMatrixC evs, base::EiVectorC evals);

        virtual void updateTransformedDensitySamples(base::EiMatrix transformed_samples) = 0;

        virtual void sampleTransformed(base::EiVector &trans_sample) = 0;

        virtual double getTransformedLogLikelihood(const base::EiVector &trans_sample) = 0;

        friend class ::boost::serialization::access;

        template<class Archive>
        void serialize(Archive &ar, const unsigned int version) {
            ar & boost::serialization::base_object<Sampler>(*this);
        }

    private:
        base::EiVector _trans_sample;

    protected:
        base::EiVector _mean;
        base::EiMatrixC _evs;
        base::EiVectorC _evals;

    };

    typedef std::shared_ptr<DensityEstimation> DensityEstimation_ptr;
}

#endif //LFNS_SAMPLERPARTICLES_H
