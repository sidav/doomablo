rarities = [
    "COMMON",
    "UNCOMMON",
    "RARE",
    "EPIC",
    "LEGENDARY",
    "MYTHIC",
]

weights = [600, 200, 80, 20, 7, 1]
total = sum(weights)

for name, w in zip(rarities, weights):
    print(f"{name:10s}: {w / total * 100:.3f}%")
