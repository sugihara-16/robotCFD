import csv
import re

input_file = "./propeller/postProcessing/forces/0/forces.dat"
output_file = "forces.csv"

header = [
    "Time",
    "Fx_pressure", "Fy_pressure", "Fz_pressure",
    "Fx_viscous",  "Fy_viscous",  "Fz_viscous",
    "Mx_pressure", "My_pressure", "Mz_pressure",
    "Mx_viscous",  "My_viscous",  "Mz_viscous"
]

data = []

pattern = re.compile(
    r"""
    ^\s*([0-9Ee\+\-\.]+)                # Time
    \s*\(\(\s*([0-9Ee\+\-\.]+)\s+([0-9Ee\+\-\.]+)\s+([0-9Ee\+\-\.]+)\s*\)\s*   # Fx_p Fy_p Fz_p
          \(\s*([0-9Ee\+\-\.]+)\s+([0-9Ee\+\-\.]+)\s+([0-9Ee\+\-\.]+)\s*\)\)\s* # Fx_v Fy_v Fz_v
    \(\(\s*([0-9Ee\+\-\.]+)\s+([0-9Ee\+\-\.]+)\s+([0-9Ee\+\-\.]+)\s*\)\s*       # Mx_p My_p Mz_p
          \(\s*([0-9Ee\+\-\.]+)\s+([0-9Ee\+\-\.]+)\s+([0-9Ee\+\-\.]+)\s*\)\)    # Mx_v My_v Mz_v
    """,
    re.VERBOSE
)

with open(input_file, "r") as f:
    for line in f:
        if line.strip().startswith("#") or not line.strip():
            continue
        m = pattern.match(line)
        if m:
            values = [float(x) for x in m.groups()]
            data.append(values)

with open(output_file, "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(header)
    writer.writerows(data)

print(f"Conversion finished. Saved in {output_file}.")
