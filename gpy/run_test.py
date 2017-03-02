#Force Agg backend to prevent conda's matplotlib PyQt4 bug
import matplotlib
matplotlib.use('Agg')
import GPy