import sympy as sp

x, t = sp.symbols('x, t', real=True)      #variables
c = sp.symbols('c', real=True)      #constante
n = sp.symbols('n', integer=True)   #entero

f = sp.exp(x)

#if f.subs(x, 0) != 0:
#    raise ValueError("f(0)!=0")

df_x = sp.diff(f, x)

#if sp.N(f.subs(x, 6)) != sp.N(df_x.subs(x, 6)):
#    raise ValueError("f(6)!= f'(6)")

N=10

beta_n = (1 + 2*n)* sp.pi/12
lambda_n = -(1 + (beta_n)**2)
xn = c * sp.exp(x) * sp.sin(beta_n * x)
tn = sp.exp(lambda_n*t)

un = xn * tn
cn=sp.simplify(1/3*sp.integrate(f/sp.exp(x)*sp.sin(beta_n*x), (x, 0, 6)))

u = 0*x
for i in range(N):
    c_i = sp.simplify(cn.subs({n: i}))
    u = u + un.subs({n: i, c: c_i})




import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

funcion_numerica = sp.lambdify((x, t), u, 'numpy')

fig, ax = plt.subplots()
x_vals = np.linspace(0, 6, 1000)
line, = ax.plot(x_vals, funcion_numerica(x_vals, 0))  # Inicialización con t=0

def actualizar(frame):
    line.set_ydata(funcion_numerica(x_vals, frame))
    ax.set_title(f'Tiempo t = {frame:.2f}')
    return line,


animacion = FuncAnimation(fig, actualizar, frames=np.linspace(0, 10, 500), interval=5)

plt.show()
