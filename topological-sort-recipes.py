import os
import sys
import argparse
from functools import reduce


def toposort2(data):
    """Topological sort.

    The expected input is a dictionary whose keys are items, and whose
    values are a set of the dependent items.

    The output is a genenerator over the items in topological order.
    """
    # http://code.activestate.com/recipes/578272-topological-sort/

    # Ignore self dependencies.
    for k, v in data.items():
        v.discard(k)
    # Find all items that don't depend on anything.
    extra_items_in_deps = reduce(set.union, data.itervalues()) - set(data.iterkeys())
    # Add empty dependences where needed
    data.update({item:set() for item in extra_items_in_deps})
    while True:
        ordered = set(item for item, dep in data.iteritems() if not dep)
        if not ordered:
            break
        for item in ordered:
           yield item
        # yield ordered
        data = {item: (dep - ordered)
                for item, dep in data.iteritems()
                    if item not in ordered}
    assert not data, "Cyclic dependencies exist among these items:\n%s" % '\n'.join(repr(x) for x in data.iteritems())


def main():
    p = argparse.ArgumentParser('Topological sort a collection of conda recipes')
    p.add_argument('recipe',
        action="store",
        metavar='RECIPE_PATH',
        nargs='+',
        help="path to one or more recipe directories"
    )
    args = p.parse_args()
    execute(args, p)


def execute(args, p):
    from conda_build.metadata import MetaData


    metadatas = [MetaData(e) for e in args.recipe if os.path.isdir(e)]
    names = {m.get_value('package/name'): m for m in metadatas}

    graph = {}
    for m in metadatas:
        all_requirements = set(m.get_value('requirements/build', []))
        all_requirements.update(m.get_value('requirements/run', []))
        all_requirements.update(m.get_value('test/requires', []))

        our_requirements = set()
        for r in all_requirements:
            if r in names:
                # remove any version specified in the requirements
                # (e.g. numpy >= 1.6) or something -- we just want the "numpy"
                if ' ' in r:
                    r = r.split()[0]
                our_requirements.add(r)

        graph[m.get_value('package/name')] = our_requirements

    order = list(toposort2(graph))
    for n in order:
        print(names[n].path)


if __name__ == '__main__':
    main()
