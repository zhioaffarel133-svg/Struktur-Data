def kruskal_mst(edges, n_nodes):
    parent = {i: i for i in range(n_nodes)}

    def find(x):
        while parent[x] != x:
            x = parent[x]
        return x

    def union(x, y):
        root_x = find(x)
        root_y = find(y)
        if root_x != root_y:
            parent[root_y] = root_x
            return True
        return False

    edges.sort(key=lambda x: x[2])
    total_weight = 0
    for u, v, weight in edges:
        if union(u, v):
            total_weight += weight
    return total_weight


# edges: (node1, node2, weight)
edges = [(0, 1, 2), (0, 2, 3), (1, 2, 1), (1, 3, 1), (2, 3, 4)]
print('Total bobot MST (Kruskal):', kruskal_mst(edges, 4))
