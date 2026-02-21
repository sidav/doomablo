# INPUT: desired percentages
percentages = [70.0, 19.0, 8.2, 2.0, 0.7, 0.1]
SCALE = 10000

total_percent = sum(percentages)

if total_percent != 100.0:
    print(
        f"Warning: total percentage is {total_percent:.3f}%. "
        f"Normalizing to 100% proportionally."
    )

    scale = 100.0 / total_percent
    percentages = [p * scale for p in percentages]
else:
    print("Percentage is OK")    

weights = [round(p / 100.0 * SCALE) for p in percentages]

# fix rounding drift
drift = SCALE - sum(weights)
weights[0] += drift  # shove error into COMMON

print(f"Final percentages (sum is {sum(percentages):.3f}):")
for i, p in enumerate(percentages):
    print(f"  Rarity {i}: {p:.3f}%")

print("Computed weights :", weights)
print("Total weight     :", sum(weights))
