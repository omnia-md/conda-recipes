#!/usr/bin/env python
# Tests that openbabel and scikit-learn can be imported together without segfault
# See https://github.com/deepchem/deepchem/issues/329

import sklearn
import sklearn.datasets
import numpy as np
import openbabel as ob
from sklearn.linear_model import LogisticRegression

dataset = sklearn.datasets.load_digits(n_class=2)
X, y = dataset.data, dataset.target

sklearn_model = LogisticRegression()
sklearn_model.fit(X, y)
