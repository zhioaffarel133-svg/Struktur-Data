def fractional_knapsack(items, capacity):
    # items = list of tuples (value, weight)
    items = sorted(items, key=lambda x: x[0]/x[1], reverse=True)
    total_value = 0.0
    for value, weight in items:
        if capacity >= weight:
            capacity -= weight
            total_value += value
        else:
            total_value += value * (capacity / weight)
            break
    return total_value


# Contoh penggunaan
items = [(60, 10), (100, 20), (120, 30)]  # (nilai, berat)
capacity = 50
max_value = fractional_knapsack(items, capacity)
print('Nilai maksimum yang dapat dibawa:', max_value)
