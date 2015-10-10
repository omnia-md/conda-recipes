import nose
import numpy as np
import ecos
import scipy.sparse


def test_1():
    prob_data = (
        np.array([-22.        , -14.5       ,  13.        ,   0.        ,  13.94907477]),
        scipy.sparse.csc_matrix([
            [-1.        ,  0.        ,  0.        ,  0.        ,  0.        ],
            [ 0.        , -1.        ,  0.        ,  0.        ,  0.        ],
            [ 0.        ,  0.        , -1.        ,  0.        ,  0.        ],
            [ 1.        ,  0.        ,  0.        ,  0.        ,  0.        ],
            [ 0.        ,  1.        ,  0.        ,  0.        ,  0.        ],
            [ 0.        ,  0.        ,  1.        ,  0.        ,  0.        ],
            [ 0.        ,  0.        ,  0.        , -1.        ,  0.        ],
            [-0.06300143,  0.05999372, -0.04139022,  0.        ,  0.        ],
            [ 0.32966768, -0.07973959, -0.61737787,  0.        ,  0.        ],
            [ 0.59441633,  0.77421041,  0.21741083,  0.        ,  0.        ],
            [ 0.        ,  0.        ,  0.        ,  0.        , -1.        ],
            [ 0.        ,  0.        ,  0.        ,  0.        ,  1.        ],
            [ 0.        ,  0.        ,  0.        , -2.        ,  0.        ]]),
        np.array([ 1.,  1.,  1.,  1.,  1.,  1., -0., -0., -0., -0.,  1.,  1., -0.]),
        {'bool_ids': [], 'f': 0, 'l': 6, 'q': [4, 3], 's': [], 'int_ids': [], 'ep': 0},
        scipy.sparse.csc_matrix(np.zeros((0, 5), dtype=np.float64)),
        np.array([], dtype=np.float64)
        )
    result = ecos.solve(*prob_data, verbose=False)
    assert result['info']['infostring'] == 'Optimal solution found'

if __name__ == '__main__':
    nose.core.runmodule()
