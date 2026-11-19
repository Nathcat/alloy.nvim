import json
import sys

def alloy_json_to_dot(filepath, state_idx=0):
    with open(filepath, "r", encoding="utf-8") as f:
        data = json.load(f)

    instances = data.get("instances", [])
    if not instances:
        print('digraph Empty { "No instances found"; }')
        return

    # Select requested temporal state (default: 0)
    inst = instances[min(state_idx, len(instances) - 1)]
    values = inst.get("values", {})

    lines = [
        "digraph AlloyInstance {",
        '  rankdir=LR;',
        '  node [shape=box];'
    ]

    nodes = set()
    edges = []

    for atom, fields in values.items():
        # Skip standalone integer atoms (0, 1, 2...) unless they have outgoing fields
        if atom.isdigit() and not fields:
            continue

        nodes.add(atom)
        for field_name, tuples in fields.items():
            for tup in tuples:
                if not tup:
                    continue
                target = str(tup[-1])
                nodes.add(target)

                # Handle ternary+ relations (e.g., A -> B -> C) by putting middle atoms in the label
                if len(tup) > 1:
                    mid = ",".join(str(x) for x in tup[:-1])
                    label = f"{field_name}[{mid}]"
                else:
                    label = field_name

                edges.append((atom, target, label))

    for node in sorted(nodes):
        # Strip trailing '$0' only in display label if desired, or keep exact atom name
        lines.append(f'  "{node}" [label="{node}"];')

    for src, dst, label in edges:
        lines.append(f'  "{src}" -> "{dst}" [label="{label}"];')

    lines.append("}")
    print("\n".join(lines))

if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit("Usage: python3 alloy2dot.py <instance.json> [state_index]")
    path = sys.argv[1]
    state = int(sys.argv[2]) if len(sys.argv) > 2 else 0
    alloy_json_to_dot(path, state)
