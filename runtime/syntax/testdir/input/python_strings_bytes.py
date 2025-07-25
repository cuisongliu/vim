# String and Bytes literals
# https://docs.python.org/3/reference/lexical_analysis.html#string-and-bytes-literals

# Strings
test = 'String with escapes \' and \" and \t'
test = "String with escapes \040 and \xFF"
test = 'String with escapes \u00A1 and \U00010605 and \N{INVERTED EXCLAMATION MARK}'
test = "String with escaped \\ backslash and ignored \
newline"
test = '''String with quotes ' and "
and escapes \t and \040 and \xFF
and escapes \u00A1 and \U00010605'''
test = """String with quotes ' and "
and escapes \t and \040 and \xFF
and escapes \u00A1 and \U00010605"""

# Raw strings
test = r'Raw string with literal \' and \" and \t'
test = R"Raw string with literal \040 and \xFF"
test = r'Raw string with literal \u00A1 and \U00010605 and \N{INVERTED EXCLAMATION MARK}'
test = R"Raw string with literal \\ backslashes and literal \
newline"
test = r'''Raw string with quotes ' and "
and literal \t and \040 and \xFF
and literal \u00A1 and \U00010605'''
test = R"""Raw string with quotes ' and "
and literal \t and \040 and \xFF
and literal \u00A1 and \U00010605"""

# Unicode literals: Prefix is allowed but ignored (https://peps.python.org/pep-0414)
test = u'String with escapes \' and \" and \t'
test = U"String with escapes \040 and \xFF"
test = u'String with escapes \u00A1 and \U00010605 and \N{INVERTED EXCLAMATION MARK}'
test = U"String with escaped \\ backslash and ignored \
newline"
test = u'''String with quotes ' and "
and escapes \t and \040 and \xFF
and escapes \u00A1 and \U00010605'''
test = U"""String with quotes ' and "
and escapes \t and \040 and \xFF
and escapes \u00A1 and \U00010605"""

# Raw Unicode literals are not allowed
test = ur'Invalid string with \' and \" and \t'
test = uR"Invalid string with \040 and \xFF"
test = Ur'Invalid string with \u00A1 and \U00010605 and \N{INVERTED EXCLAMATION MARK}'
test = UR"Invalid string with \\ backslashes and literal \
newline"
test = ru'Invalid string with \' and \" and \t'
test = rU"Invalid string with \040 and \xFF"
test = Ru'Invalid string with \u00A1 and \U00010605 and \N{INVERTED EXCLAMATION MARK}'
test = RU"Invalid string with \\ backslashes and literal \
newline"
test = ur'''Invalid string with ' and "
and \t and \040 and \xFF
and \u00A1 and \U00010605'''
test = RU"""Invalid string with ' and "
and \t and \040 and \xFF
and \u00A1 and \U00010605"""

# Formatted string literals (f-strings)
# https://docs.python.org/3/reference/lexical_analysis.html#f-strings
test = f'F-string with escapes \' and \" and \t and fields {foo} and {bar}'
test = F"F-string with escapes \040 and \xFF and fields {foo} and {bar}"
test = f'F-string with escapes \u00A1 and \U00010605 and \N{INVERTED EXCLAMATION MARK} and fields {foo} and {bar}'
test = F"F-string with literal {{field}} and fields {foo} and {bar}"
test = f'''F-string with quotes ' and "
and escapes \t and \040 and \xFF
and escapes \u00A1 and \U00010605
and fields {1}, {2} and {1
    +
    2}'''
test = F"""F-string with quotes ' and "
and escapes \t and \040 and \xFF
and escapes \u00A1 and \U00010605
and fields {1}, {2} and {1
    +
    2}"""

# Raw formatted string literals
test = fr'Raw f-string with literal \' and \" and \t and fields {foo} and {bar}'
test = fR"Raw f-string with literal \040 and \xFF and fields {foo} and {bar}"
test = Fr'Raw f-string with literal \u00A1 and \U00010605 and \N{INVERTED EXCLAMATION MARK} and fields {foo} and {bar}'
test = FR"Raw f-string with literal {{field}} and fields {foo} and {bar}"
test = rf'Raw f-string with literal \' and \" and \t and fields {foo} and {bar}'
test = rF"Raw f-string with literal \040 and \xFF and fields {foo} and {bar}"
test = Rf'Raw f-string with literal \u00A1 and \U00010605 and \N{INVERTED EXCLAMATION MARK} and fields {foo} and {bar}'
test = RF"Raw f-string with literal {{field}} and fields {foo} and {bar}"
test = fr'''Raw f-string with quotes ' and "
and literal \t and \040 and \xFF
and literal \u00A1 and \U00010605
and fields {1}, {2} and {1
    +
    2}'''
test = RF"""Raw f-string with quotes ' and "
and literal \t and \040 and \xFF
and literal \u00A1 and \U00010605
and fields {1}, {2} and {1
    +
    2}"""

# Bytes
test = b'Bytes with escapes \' and \" and \t'
test = B"Bytes with escapes \040 and \xFF"
test = b'Bytes with literal \u00A1 and \U00010605 and \N{INVERTED EXCLAMATION MARK}'
test = B"Bytes with escaped \\ backslash and ignored \
newline"
test = b'''Bytes with quotes ' and "
and escapes \t and \040 and \xFF
and literal \u00A1 and \U00010605'''
test = B"""Bytes with quotes ' and "
and escapes \t and \040 and \xFF
and literal \u00A1 and \U00010605"""

# Raw bytes
test = br'Raw bytes with literal \' and \" and \t'
test = bR"Raw bytes with literal \040 and \xFF"
test = Br'Raw bytes with literal \u00A1 and \U00010605 and \N{INVERTED EXCLAMATION MARK}'
test = BR"Raw bytes with literal \\ backslashes and literal \
newline"
test = rb'Raw bytes with literal \' and \" and \t'
test = rB"Raw bytes with literal \040 and \xFF"
test = Rb'Raw bytes with literal \u00A1 and \U00010605 and \N{INVERTED EXCLAMATION MARK}'
test = RB"Raw bytes with literal \\ backslashes and literal \
newline"
test = br'''Raw bytes with quotes ' and "
and literal \t and \040 and \xFF
and literal \u00A1 and \U00010605'''
test = RB"""Raw bytes with quotes ' and "
and literal \t and \040 and \xFF
and literal \u00A1 and \U00010605"""
