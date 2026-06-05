from pathlib import Path
text = Path('TableOfContents.md').read_text(encoding='utf-8')
replacements = {
    '- [Preface](#sec-preface)': '- [Preface](chapters/chapter-00-preface.md#sec-preface)',
    '- [General Introduction](#sec-general-introduction)': '- [General Introduction](chapters/chapter-01-general-introduction.md#sec-general-introduction)',
    '- [ML Fitting of Mixture Models](#sec-ml-fitting-of-mixture-models)': '- [ML Fitting of Mixture Models](chapters/chapter-02-ml-fitting-of-mixture-models.md#sec-ml-fitting-of-mixture-models)',
    '- [Multivariate Normal Mixtures](#sec-multivariate-normal-mixtures)': '- [Multivariate Normal Mixtures](chapters/chapter-03-multivariate-normal-mixtures.md#sec-multivariate-normal-mixtures)',
    '- [Bayesian Approach to Mixture Analysis](#sec-bayesian-approach-to-mixture-analysis)': '- [Bayesian Approach to Mixture Analysis](chapters/chapter-04-bayesian-approach-to-mixture-analysis.md#sec-bayesian-approach-to-mixture-analysis)',
    '- [Mixtures with Nonnormal Components](#sec-mixtures-with-nonnormal-components)': '- [Mixtures with Nonnormal Components](chapters/chapter-05-mixtures-with-nonnormal-components.md#sec-mixtures-with-nonnormal-components)',
    '- [Assessing the Number of Components in Mixture Models](#sec-assessing-the-number-of-components-in-mixture-models)': '- [Assessing the Number of Components in Mixture Models](chapters/chapter-06-assessing-the-number-of-components-in-mixture-models.md#sec-assessing-the-number-of-components-in-mixture-models)',
    '- [Multivariate t Mixtures](#sec-multivariate-t-mixtures)': '- [Multivariate t Mixtures](chapters/chapter-07-multivariate-t-mixtures.md#sec-multivariate-t-mixtures)',
    '- [Mixtures of Factor Analyzers](#sec-mixtures-of-factor-analyzers)': '- [Mixtures of Factor Analyzers](chapters/chapter-08-mixtures-of-factor-analyzers.md#sec-mixtures-of-factor-analyzers)',
    '- [Fitting Mixture Models to Binned Data](#sec-fitting-mixture-models-to-binned-data)': '- [Fitting Mixture Models to Binned Data](chapters/chapter-09-fitting-mixture-models-to-binned-data.md#sec-fitting-mixture-models-to-binned-data)',
    '- [Mixture Models for Failure-Time Data](#sec-mixture-models-for-failure-time-data)': '- [Mixture Models for Failure-Time Data](chapters/chapter-10-mixture-models-for-failure-time-data.md#sec-mixture-models-for-failure-time-data)',
    '- [Mixture Analysis of Directional Data](#sec-mixture-analysis-of-directional-data)': '- [Mixture Analysis of Directional Data](chapters/chapter-11-mixture-analysis-of-directional-data.md#sec-mixture-analysis-of-directional-data)',
    '- [Variants of the EM Algorithm for Large Databases](#sec-variants-of-the-em-algorithm-for-large-databases)': '- [Variants of the EM Algorithm for Large Databases](chapters/chapter-12-variants-of-the-em-algorithm-for-large-databases.md#sec-variants-of-the-em-algorithm-for-large-databases)',
    '- [Hidden Markov Models](#sec-hidden-markov-models)': '- [Hidden Markov Models](chapters/chapter-13-hidden-markov-models.md#sec-hidden-markov-models)',
}
for old, new in replacements.items():
    if old not in text:
        raise ValueError(f'Missing expected line: {old}')
    text = text.replace(old, new)
Path('TableOfContents.md').write_text(text, encoding='utf-8')
print('Updated chapter links in TableOfContents.md')
