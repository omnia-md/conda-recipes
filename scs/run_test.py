import platform
import nose
from nose.tools import assert_raises, assert_almost_equals
import numpy as np
import scipy.sparse as sp
from numpy.random import *
from numpy import *
import scs


# global data structures for problem
c = np.array([-1.])
b = np.array([1., -0.])
A = sp.csc_matrix([1., -1.]).T.tocsc()
data = {'A':A, 'b':b, 'c':c}
cone = {'q': [], 'l': 2}

FAIL = 'Failure' # scs code for failure

def assert_(str1, str2):
  if (str1 != str2):
    print("assert failure: %s != %s" % (str1, str2))
  assert str1 == str2

def check_solution(solution, expected):
  assert_almost_equals(solution, expected, places=2)

def check_failure(sol):
  assert sol['info']['status'] == FAIL

def check_infeasible(sol):
  assert_(sol['info']['status'], 'Infeasible')

def check_unbounded(sol):
  assert_(sol['info']['status'], 'Unbounded')


def test_problems():
  sol = scs.solve(data, cone)
  yield check_solution, sol['x'][0], 1

  new_cone = {'q':[2], 'l': 0}
  sol = scs.solve(data, new_cone)
  yield check_solution, sol['x'][0], 0.5

  sol = scs.solve(data, cone, use_indirect = True )
  yield check_solution, sol['x'][0], 1

  sol = scs.solve(data, new_cone, use_indirect = True )
  yield check_solution, sol['x'][0], 0.5


if platform.python_version_tuple() < ('3','0','0'):
  def test_problems_with_longs():
    new_cone = {'q': [], 'l': long(2)}
    sol = scs.solve(data, new_cone)
    yield check_solution, sol['x'][0], 1
    sol = scs.solve(data, new_cone, use_indirect=True )
    yield check_solution, sol['x'][0], 1

    new_cone = {'q':[long(2)], 'l': 0}
    sol = scs.solve(data, new_cone)
    yield check_solution, sol['x'][0], 0.5
    sol = scs.solve(data, new_cone, use_indirect=True )
    yield check_solution, sol['x'][0], 0.5

def check_keyword(error_type, keyword, value):
  assert_raises(error_type, scs.solve, data, cone, **{keyword: value})

def test_failures():
  yield assert_raises, TypeError, scs.solve
  yield assert_raises, ValueError, scs.solve, data, {'q':[4], 'l':-2}
  # yield check_keyword, ValueError, 'max_iters', -1
  # python 2.6 and before just cast float to int
  if platform.python_version_tuple() >= ('2', '7', '0'):
    yield check_keyword, TypeError, 'max_iters', 1.1

  yield check_failure, scs.solve( data, {'q':[1], 'l': 0} )


######################################################



def genFeasible(K, n, density):
    m = getConeDims(K)

    z = randn(m,)
    y = proj_dual_cone(z, K)  # y = s - z;
    s = y - z  # s = proj_cone(z,K)

    A = sp.rand(m, n, density, format='csc')
    A.data = randn(A.nnz)
    x = randn(n)
    c = -transpose(A).dot(y)
    b = A.dot(x) + s

    data = {'A': A, 'b': b, 'c': c}
    return data, dot(c, x)

def genInfeasible(K, n):
    m = getConeDims(K)

    z = randn(m,)
    y = proj_dual_cone(z, K)  # y = s - z;
    A = randn(m, n)
    A = A - outer(y, transpose(A).dot(y)) / linalg.norm(y) ** 2  # dense...

    b = randn(m);
    b = -b / dot(b, y);

    data = {'A':sp.csc_matrix(A), 'b':b, 'c':randn(n)}
    return data

def genUnbounded(K, n):
    m = getConeDims(K)

    z = randn(m);
    s = proj_cone(z, K);
    A = randn(m, n);
    x = randn(n);
    A = A - outer(s + A.dot(x), x) / linalg.norm(x) ** 2;  # dense...
    c = randn(n);
    c = -c / dot(c, x);

    data = {'A':sp.csc_matrix(A), 'b':randn(m), 'c':c}
    return data

def pos(x):
    return (x + abs(x)) / 2

def getConeDims(K):
    l = K['f'] + K['l']
    for i in range(0, len(K['q'])):
        l = l + K['q'][i];

    for i in range(0, len(K['s'])):
        l = l + get_sd_cone_size(K['s'][i]);

    l = l + K['ep'] * 3;
    l = l + K['ed'] * 3;
    l = l + len(K['p']) * 3;
    return int(l)

def proj_dual_cone(z, c):
    return z + proj_cone(-z, c)

def get_sd_cone_size(n):
    return int((n * (n + 1)) / 2)

def proj_cone(z, c):
    z = copy(z)
    free_len = c['f']
    lp_len = c['l']
    q = c['q']
    s = c['s']
    p = c['p']
    # free/zero cone
    z[0:free_len] = 0;
    # lp cone
    z[free_len:lp_len + free_len] = pos(z[free_len:lp_len + free_len])
    # SOCs
    idx = lp_len + free_len;
    for i in range(0, len(q)):
        z[idx:idx + q[i]] = proj_soc(z[idx:idx + q[i]])
        idx = idx + q[i]
    # SDCs
    for i in range(0, len(s)):
        sz = get_sd_cone_size(s[i])
        z[idx:idx + sz] = proj_sdp(z[idx:idx + sz], s[i])
        idx = idx + sz
    # Exp primal
    for i in range(0, c['ep']):
        z[idx:idx + 3] = project_exp_bisection(z[idx:idx + 3])
        idx = idx + 3
    # Exp dual
    for i in range(0, c['ed']):
        z[idx:idx + 3] = z[idx:idx + 3] + project_exp_bisection(-z[idx:idx + 3])
        idx = idx + 3
    # Power
    for i in range(0, len(p)):
        if (p[i] >= 0): # primal
            z[idx:idx + 3] = proj_pow(z[idx:idx + 3], p[i])
        else: # dual
            z[idx:idx + 3] = z[idx:idx + 3] + proj_pow(-z[idx:idx + 3], -p[i])
        idx = idx + 3
    return z

def proj_soc(tt):
    tt = copy(tt)
    if len(tt) == 0:
        return
    elif len(tt) == 1:
        return pos(tt)

    v1 = tt[0]
    v2 = tt[1:];
    if linalg.norm(v2) <= -v1:
        v2 = zeros(len(v2))
        v1 = 0
    elif linalg.norm(v2) > abs(v1):
        v2 = 0.5 * (1 + v1 / linalg.norm(v2)) * v2
        v1 = linalg.norm(v2)
    tt[0] = v1
    tt[1:] = v2
    return tt

def proj_sdp(z, n):
    z = copy(z)
    if n == 0:
        return
    elif n == 1:
        return pos(z)
    tidx = triu_indices(n)
    tidx = (tidx[1], tidx[0])
    didx = diag_indices(n)

    a = zeros((n, n))
    a[tidx] = z
    a = (a + transpose(a))
    a[didx] = a[didx] / sqrt(2.)

    w, v = linalg.eig(a)  # cols of v are eigenvectors
    w = pos(w)
    a = dot(v, dot(diag(w), transpose(v)))
    a[didx] = a[didx] / sqrt(2.)
    z = a[tidx]
    return z

def proj_pow(v, a):
    CONE_MAX_ITERS = 20;
    CONE_TOL = 1e-8;

    if (v[0]>=0 and v[1]>=0 and (v[0]**a) * (v[1]**(1-a)) >= abs(v[2])):
        return v

    if (v[0]<=0 and v[1]<=0 and ((-v[0]/a)**a)*((-v[1]/(1-a))**(1-a)) >= abs(v[2])):
        return zeros(3,)

    xh = v[0];
    yh = v[1];
    zh = v[2];
    rh = abs(zh);
    r = rh / 2;
    for iter in range(0, CONE_MAX_ITERS):
        x = calcX(r, xh, rh, a);
        y = calcX(r, yh, rh, 1-a);

        f = calcF(x,y,r,a);
        if abs(f) < CONE_TOL:
            break

        dxdr = calcdxdr(x,xh,rh,r,a);
        dydr = calcdxdr(y,yh,rh,r, (1-a));
        fp = calcFp(x,y,dxdr,dydr,a);

        r = min(max(r - f/fp,0), rh);

    z = sign(zh) * r;
    v[0] = x
    v[1] = y
    v[2] = z
    return v

def calcX(r, xh, rh, a):
    return max(0.5 * (xh + sqrt(xh*xh + 4 * a * (rh - r) * r)), 1e-12)

def calcdxdr(x,xh,rh,r, a):
    return  a * (rh - 2*r) / (2 * x - xh)

def calcF(x,y,r,a):
    return (x**a) * (y**(1-a)) - r

def calcFp(x,y,dxdr,dydr,a):
    return (x**a) * (y**(1-a)) * (a * dxdr / x + (1-a) * dydr / y) - 1

def project_exp_bisection(v):
    v = copy(v)
    r = v[0]; s = v[1]; t = v[2]
    # v in cl(Kexp)
    if (s * exp(r / s) <= t and s > 0) or (r <= 0 and s == 0 and t >= 0):
        return v
    # -v in Kexp^*
    if (-r < 0 and r * exp(s / r) <= -exp(1) * t) or (-r == 0 and -s >= 0 and -t >= 0):
        return zeros(3,)
    # special case with analytical solution
    if r < 0 and s < 0:
        v[1] = 0
        v[2] = max(v[2], 0)
        return v

    x = copy(v)
    ub, lb = getRhoUb(v)
    for iter in range(0, 100):
        rho = (ub + lb) / 2
        g, x = calcGrad(v, rho, x)
        if g > 0:
            lb = rho
        else:
            ub = rho
        if (ub - lb < 1e-6):
            break
    return x

def getRhoUb(v):
    lb = 0
    rho = 2 ** (-3)
    g, z = calcGrad(v, rho, v)
    while g > 0:
        lb = rho
        rho = rho * 2
        g, z = calcGrad(v, rho, z)
    ub = rho
    return ub, lb

def calcGrad(v, rho, warm_start):
    x = solve_with_rho(v, rho, warm_start[1])
    if x[1] == 0:
        g = x[0]
    else:
        g = (x[0] + x[1] * log(x[1] / x[2]))
    return g, x

def solve_with_rho(v, rho, w):
    x = zeros(3)
    x[2] = newton_exp_onz(rho, v[1], v[2], w)
    x[1] = (1 / rho) * (x[2] - v[2]) * x[2]
    x[0] = v[0] - rho
    return x

def newton_exp_onz(rho, y_hat, z_hat, w):
    t = max(max(w - z_hat, -z_hat), 1e-6)
    for iter in range(0, 100):
        f = (1 / rho ** 2) * t * (t + z_hat) - y_hat / rho + log(t / rho) + 1
        fp = (1 / rho ** 2) * (2 * t + z_hat) + 1 / t

        t = t - f / fp
        if t <= -z_hat:
            t = -z_hat
            break
        elif t <= 0:
            t = 0
            break
        elif abs(f) < 1e-6:
            break
    return t + z_hat

################################################################



class TestRandom(object):
    num_feas = 50
    num_unb = 10
    num_infeas = 10

    opts={'max_iters':100000,'eps':1e-5} # better accuracy than default to ensure test pass
    K = {'f':10, 'l':25, 'q':[5, 10, 0 ,1], 's':[2, 1, 2, 0, 1], 'ep':0, 'ed':0, 'p':[0.25, -0.75, 0.33, -0.33, 0.2]}
    m = getConeDims(K)

    def test_feasible(self):
        for i in range(self.num_feas):
            data, p_star = genFeasible(self.K, n = self.m // 3, density = 0.1)

            sol = scs.solve(data, self.K, **self.opts)
            yield check_solution, dot(data['c'],sol['x']), p_star
            yield check_solution, dot(-data['b'],sol['y']), p_star

            sol = scs.solve(data, self.K, use_indirect=True, **self.opts)
            yield check_solution, dot(data['c'],sol['x']), p_star
            yield check_solution, dot(-data['b'],sol['y']), p_star

    def test_infeasible(self):
        for i in range(self.num_infeas):
            data = genInfeasible(self.K, n = self.m // 3)

            yield check_infeasible, scs.solve(data, self.K, **self.opts)
            yield check_infeasible, scs.solve(data, self.K, use_indirect=True, **self.opts)

    def test_unbounded(self):
        for i in range(self.num_unb):
            data = genUnbounded(self.K, n = self.m // 2)

            yield check_unbounded, scs.solve(data, self.K, **self.opts)
            yield check_unbounded, scs.solve(data, self.K, use_indirect=True, **self.opts)

class TestSDP(object):
    opts={'max_iters':100000,'eps':1e-5} # better accuracy than default to ensure test pass
    K = {'f':10, 'l':15, 'q':[5, 10, 0 ,1], 's':[2, 1, 2, 0, 1], 'ep':10, 'ed':10, 'p':[0.25, -0.75, 0.33, -0.33, 0.2]}
    m = getConeDims(K)
    num_feas = 10
    num_unb = 10
    num_infeas = 10

    def test_feasible(self):
        for i in range(self.num_feas):
            data, p_star = genFeasible(self.K, n = self.m // 3, density = 0.1)

            sol = scs.solve(data, self.K, **self.opts)
            yield check_solution, dot(data['c'],sol['x']), p_star
            yield check_solution, dot(-data['b'],sol['y']), p_star

            sol = scs.solve(data, self.K, use_indirect=True, **self.opts)
            yield check_solution, dot(data['c'],sol['x']), p_star
            yield check_solution, dot(-data['b'],sol['y']), p_star

    def test_infeasible(self):
        for i in range(self.num_infeas):
            data = genInfeasible(self.K, n = self.m // 3)

            yield check_infeasible, scs.solve(data, self.K, **self.opts)
            yield check_infeasible, scs.solve(data, self.K, use_indirect=True, **self.opts)

    def test_unbounded(self):
        for i in range(self.num_unb):
            data = genUnbounded(self.K, n = self.m // 2)

            yield check_unbounded, scs.solve(data, self.K, **self.opts)
            yield check_unbounded, scs.solve(data, self.K, use_indirect=True, **self.opts)


if __name__ == '__main__':
    nose.core.runmodule()
