import pyublas
import numpy
import pyublas.testhelp_ext as te





def test_invalid_ok():
    v = numpy.array([1,2,3,4,5], dtype=numpy.float64)
    assert te.size_or_neg_1(None) == -1
    assert te.size_or_neg_1(v) == 5

def test_array_scalars():
    u = numpy.int32(5)
    assert te.dbl_int(u) == 10

def test_regular_vector():
    a = numpy.ones((5,), dtype=float)
    assert (te.dbl_numpy_vec(a) == 2*a).all()

def test_0d_array():
    a = numpy.ones((), dtype=float)

    # 0d converted to 1d, single element
    dbl_1 = te.dbl_numpy_vec(a)
    assert dbl_1.shape == (1,)
    assert dbl_1[0] == 2

    # everything preserved
    dbl_2 = te.dbl_numpy_vec_keep_shape_1(a)
    assert dbl_2.shape == ()
    assert dbl_2[()] == 2

    # everything preserved
    dbl_3 = te.dbl_numpy_vec_keep_shape_2(a)
    assert dbl_3.shape == ()
    assert dbl_3[()] == 2

def test_vec_slice_noncontig():
    a_orig = numpy.ones((10,), dtype=float)
    a = a_orig[::2]

    # whole vector multiplied (!) -> noncontiguous slice
    dbl_1 = te.dbl_numpy_vec(a)
    assert dbl_1.shape == (10,)
    assert (dbl_1 == 2*a_orig).all()

    # only slice multiplied
    dbl_2 = te.dbl_numpy_vec_keep_shape_1(a)
    assert dbl_2.shape == (5,)
    assert (dbl_2 == 2*a).all()

    # same here
    dbl_3 = te.dbl_numpy_vec_keep_shape_2(a)
    assert dbl_3.shape == (5,)
    assert (dbl_3 == 2*a).all()

    # when copying, take strides into account
    dbl_4 = te.dbl_ublas_vec(a)
    assert dbl_4.shape == (5,)
    assert (dbl_4 == 2*a).all()

    # strided vector should automatically respect strides
    dbl_5 = te.dbl_numpy_strided_vec(a)
    assert dbl_5.shape == (5,)
    assert (dbl_5 == 2*a).all()

    # returned strided vector should behave the same
    dbl_6 = te.dbl_numpy_strided_vec_ret(a)
    assert dbl_6.shape == (5,)
    assert (dbl_6 == 2*a).all()

def test_vec_slice_noncontig_inplace():
    a_orig = numpy.ones((10,), dtype=float)
    a = a_orig[::2]

    te.dbl_numpy_vec_inplace(a)
    assert (a_orig == 2).all()

    a_orig = numpy.ones((10,), dtype=float)
    a = a_orig[::2]

    te.dbl_numpy_strided_vec_inplace(a)
    assert (a_orig[::2] == 2).all()
    assert (a_orig[1::2] == 1).all()

def test_vec_slice_contig_inplace():
    a_orig = numpy.ones((10,), dtype=float)
    a = a_orig[4:7]

    te.dbl_numpy_vec_inplace(a)
    assert (a_orig[4:7] == 2).all()
    assert (a_orig[0:4] == 1).all()
    assert (a_orig[7:10] == 1).all()

def test_matrix():
    a = numpy.ones((10,10), dtype=float)

    dbl_0 = te.dbl_numpy_mat(a)
    assert dbl_0.shape == (10,10)
    assert (dbl_0 == 2).all()

    dbl_1 = te.dbl_ublas_mat(a)
    assert dbl_1.shape == (10,10)
    assert (dbl_1 == 2).all()

def test_matrix_cm():
    a = numpy.ones((10,10), dtype=float, order="F")

    dbl_0 = te.dbl_numpy_mat_cm(a)
    assert dbl_0.shape == (10,10)
    assert (dbl_0 == 2).all()

def test_matrix_slice():
    a = numpy.ones((10,10), dtype=float)

    dbl_0 = te.dbl_numpy_mat(a[3:7])
    assert dbl_0.shape == (4,10)
    assert (dbl_0 == 2).all()

    try:
        dbl_0 = te.dbl_numpy_mat(a[:, 3:7])
        assert False
    except TypeError:
        pass

def test_matrix_slice_cm():
    a = numpy.ones((10,10), dtype=float, order="F")

    try:
        dbl_0 = te.dbl_numpy_mat_cm(a[3:7])
        assert False
    except TypeError:
        pass

    dbl_0 = te.dbl_numpy_mat_cm(a[:, 3:7])
    assert dbl_0.shape == (10,4)
    assert (dbl_0 == 2).all()

def test_matrix_slice_inplace():
    a = numpy.ones((10,10), dtype=float)

    te.dbl_numpy_mat_inplace(a[3:7])
    assert a.sum() == 140

    try:
        te.dbl_numpy_mat_inplace(a[:, 3:7])
        assert False
    except TypeError:
        pass

def test_empty_and_resize():
    v = te.make_resized_vector(0)
    assert v.shape == (0,)

    v = te.make_resized_vector(1)
    assert v.shape == (1,)

    v = te.make_resized_vector(5)
    assert v.shape == (5,)

def test_negative_stride():
    a_orig = numpy.ones((10,), dtype=float)
    a = a_orig[::-2]

    te.dbl_numpy_vec_inplace(a)
    assert (a_orig[1:] == 2).all()
    assert (a_orig[0] == 1).all()

    a_orig = numpy.ones((10,), dtype=float)
    a = a_orig[::-2]

    te.dbl_numpy_strided_vec_inplace(a)
    assert (a_orig[::-2] == 2).all()
    assert (a_orig[-2::-2] == 1).all()

def test_no_2d_strided_vector():
    a_orig = numpy.ones((10,10), dtype=float)
    a = a_orig[:3, :3]

    try:
        te.dbl_numpy_strided_vec_inplace(a)
        assert False
    except ValueError:
        pass

def test_2d():
    a = numpy.ones((10,10), dtype=float)

    te.dbl_numpy_vec_inplace(a)
    assert (a == 2).all()

    a_orig = numpy.ones((10,10), dtype=float)
    a = a_orig[::-1, ::-1]

    te.dbl_numpy_vec_inplace(a)
    assert (a_orig == 2).all()




if __name__ == "__main__":
    import sys
    if len(sys.argv) > 1:
        exec(sys.argv[1])
    else:
        from py.test.cmdline import main
        main([__file__])
