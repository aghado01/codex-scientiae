[Page 1]

# A Robust Spline Approach in Partially Linear Additive Models

**Graciela Boente** and **Alejandra Mercedes Martínez**

CONICET and Universidad de Buenos Aires, Argentina; CONICET and Universidad Nacional de Luján, Argentina

## Abstract

Partially linear additive models generalize linear regression models by assuming that the relationship between the response and a set of explanatory variables is linear on some of the covariates, while the other ones enter into the model through unknown univariate smooth functions. The harmful effect of outliers either in the residuals or in the covariates involved in the linear component has been described in the situation of partially linear models, that is, when only one nonparametric component is involved. When dealing with additive components, the problem of providing reliable estimators when atypical data arise is of practical importance motivating the need of robust procedures. Based on this fact, a family of robust estimators for partially linear additive models that combines B-splines with robust linear MM-regression estimators is proposed. Under mild assumptions, consistency results and rates of convergence for the proposed estimators are derived. Furthermore, the asymptotic normality for the linear regression estimators is obtained. A Monte Carlo study is carried out to compare, under different models and contamination schemes, the performance of the robust MM-proposal based on B-splines with its classical counterpart and also with a quantile approach. The obtained results show the benefits of using the robust MM-approach. The analysis of a real data set illustrates the usefulness of the proposed method.

## 1. Introduction

Different approaches have been considered in the literature to deal with the well-known "curse of dimensionality" of fully nonparametric regression models. Among others, we can mention additive, single–index, varying coefficient and partial linear models. Specifically, partial linear models allow the response variable to depend linearly on some covariates, while the others are modeled in a fully non-parametric way. More precisely, in such models we deal with observations $(Y_i, Z_i^t, X_i^t)^t$ independent and identically distributed (i.i.d.) with the same distribution as $(Y, Z^t, X^t)^t$ where $Y \in \mathbb{R}$, $Z \in \mathbb{R}^q$ and $X \in \mathbb{R}^p$. The response and covariates are related through

$$
Y = m(Z, \mathbf{X}) + \sigma\,\varepsilon = \beta^{\tau} Z + \eta(\mathbf{X}) + \sigma\,\varepsilon,
$$
