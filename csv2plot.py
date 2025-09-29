import pandas as pd
import matplotlib.pyplot as plt
import math

csv_file = "forces.csv"
df = pd.read_csv(csv_file)

time = df["Time"]
columns = df.columns[1:]


ncols = 2
nrows = math.ceil(len(columns) / ncols)


nrows = 6
ncols = 2

fig, axes = plt.subplots(nrows, ncols, figsize=(12, 3*nrows), sharex=True)
axes = axes.flatten() 

for i, col in enumerate(columns):
    ax = axes[i]
    ax.plot(time, df[col])
    ax.set_title(col, fontsize=10)
    ax.grid(True)
    if i % ncols == 0:
        ax.set_ylabel("Value")
for ax in axes[len(columns):]:
    ax.axis('off')

axes[-2].set_xlabel("Time [s]")
axes[-1].set_xlabel("Time [s]")

fig.suptitle("OpenFOAM Forces and Moments", fontsize=14)
plt.tight_layout(rect=[0, 0, 1, 0.96])
plt.savefig("forces_grid.png", dpi=300)
plt.show()
