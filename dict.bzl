ValueInfo = provider(
    doc = "Arbitrary value wrapper",
    fields = {
        "value": "The arbitrary value",
    },
)

def _define_value_impl(ctx):
    return [ValueInfo(value = ctx.attr.value)]

def _merge_dict_impl(ctx):
    result = {}
    for label in ctx.attr.deps:
        result.update(label[ValueInfo].value)

    return [ValueInfo(value = result)]

define_label_keyed_string_dict = rule(
    doc = "Rule for defining a label keyed string dict.",
    implementation = _define_value_impl,
    attrs = {
        "value": attr.label_keyed_string_dict(
            doc = "The target dict",
        ),
    },
)

define_string_dict = rule(
    doc = "Rule for defining a string dict.",
    implementation = _define_value_impl,
    attrs = {
        "value": attr.string_dict(
            doc = "The target dict",
        ),
    },
)

define_string_list_dict = rule(
    doc = "Rule for defining a string list dict.",
    implementation = _define_value_impl,
    attrs = {
        "value": attr.string_list_dict(
            doc = "The target dict",
        ),
    },
)

merge_dict = rule(
    implementation = _merge_dict_impl,
    attrs = {
        "deps": attr.label_list(
          doc = "The list of dict that will be merged",
          providers = [ValueInfo],
        ),
    },
)
