# Fix conda's Matplotlib PyQt4 issue
import matplotlib
matplotlib.use('Agg')
import lomap