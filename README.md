# rules_dict

This rule provides a workaround for the problem that `dict` cannot currently be combined (cf. https://github.com/bazelbuild/bazel/issues/12457).

```starlark
load("@bazel_rules_dict//:dict.bzl", "define_string_dict", "merge_dict")

define_string_dict(
    name = "base_dict",
    value = {
        "X": "1",
    },
)

define_string_dict(
    name = "extension_dict",
    value = select({
        "@bazel_tools//src/conditions:windows": {
            "Y": "2",
        },
        "//conditions:default": {
            "X": "3",
            "Y": "4",
        },
    }),
)

merge_dict(
    name = "combined_dict",
    deps = [
        ":base_dict",
        ":extension_dict",
    ],
    # =>
    #  { "X": "1" } + select({
    #    "@bazeL_tools//src/conditions:windows": { "Y": "2" },
    #    "//conditions:default": { "X": "3", "Y": "4" },
    #  }),
)

some_rule(
    dict_label_attr = ":combined_dict",
    ...
)
```

## ATTENTION!
`merge_dict` provides `ValueInfo`, which is of course not a `dict` itself.\
Also, if an attribute of a rule requires a `dict`, you cannot pass a `label` instead of a `dict`.\
Therefore, it does not work seamlessly with existing rules.

## Notes
Tested with Bazel 4.2.1
