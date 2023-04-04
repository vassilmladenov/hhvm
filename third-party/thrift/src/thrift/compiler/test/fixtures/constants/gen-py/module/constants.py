#
# Autogenerated by Thrift
#
# DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
#  @generated
#

from __future__ import absolute_import
import sys
from thrift.util.Recursive import fix_spec
from thrift.Thrift import TType, TMessageType, TPriority, TRequestContext, TProcessorEventHandler, TServerInterface, TProcessor, TException, TApplicationException, UnimplementedTypedef
from thrift.protocol.TProtocol import TProtocolException



from .ttypes import UTF8STRINGS, EmptyEnum, City, Company, Internship, Range, struct1, struct2, struct3, struct4, union1, union2, MyCompany, MyStringIdentifier, MyIntIdentifier, MyMapIdentifier

myInt = 1337

name = "Mark Zuckerberg"

multi_line_string = """This
is a
multi line string.
"""

states = [
  {
    "San Diego" : 3211000,
    "Sacramento" : 479600,
    "SF" : 837400,
  },
  {
    "New York" : 8406000,
    "Albany" : 98400,
  },
]

x = 1.00000

y = 1000000

z = 1.00000e+09

zeroDoubleValue = 0.00000

longDoubleValue = 2.59961e-05

my_company = 0

foo = "foo"

bar = 42

mymap = {
  "keys" : "values",
}

instagram = Internship(**{
  "weeks" : 12,
  "title" : "Software Engineer",
  "employer" :   3,
  "compensation" : 1200.00,
  "school" : "Monters University",
})

partial_const = Internship(**{
  "weeks" : 8,
  "title" : "Some Job",
})

kRanges = [
  Range(**{
    "min" : 1,
    "max" : 2,
  }),
  Range(**{
    "min" : 5,
    "max" : 6,
  }),
]

internList = [
  Internship(**{
    "weeks" : 12,
    "title" : "Software Engineer",
    "employer" :     3,
    "compensation" : 1200.00,
    "school" : "Monters University",
  }),
  Internship(**{
    "weeks" : 10,
    "title" : "Sales Intern",
    "employer" :     0,
    "compensation" : 1000.00,
  }),
]

pod_0 = struct1(**{
})

pod_s_0 = struct1(**{
})

pod_1 = struct1(**{
  "a" : 10,
  "b" : "foo",
})

pod_s_1 = struct1(**{
  "a" : 10,
  "b" : "foo",
})

pod_2 = struct2(**{
  "a" : 98,
  "b" : "gaz",
  "c" : struct1(**{
    "a" : 12,
    "b" : "bar",
  }),
  "d" : [
    11,
    22,
    33,
  ],
})

pod_trailing_commas = struct2(**{
  "a" : 98,
  "b" : "gaz",
  "c" : struct1(**{
    "a" : 12,
    "b" : "bar",
  }),
  "d" : [
    11,
    22,
    33,
  ],
})

pod_s_2 = struct2(**{
  "a" : 98,
  "b" : "gaz",
  "c" : struct1(**{
    "a" : 12,
    "b" : "bar",
  }),
  "d" : [
    11,
    22,
    33,
  ],
})

pod_3 = struct3(**{
  "a" : "abc",
  "b" : 456,
  "c" : struct2(**{
    "a" : 888,
    "c" : struct1(**{
      "b" : "gaz",
    }),
    "d" : [
      1,
      2,
      3,
    ],
  }),
})

pod_s_3 = struct3(**{
  "a" : "abc",
  "b" : 456,
  "c" : struct2(**{
    "a" : 888,
    "c" : struct1(**{
      "b" : "gaz",
    }),
    "d" : [
      1,
      2,
      3,
    ],
  }),
})

pod_4 = struct4(**{
  "a" : 1234,
  "b" : 0.333000,
  "c" : 25,
})

u_1_1 = union1(**{
  "i" : 97,
})

u_1_2 = union1(**{
  "d" : 5.60000,
})

u_1_3 = union1(**{
})

u_2_1 = union2(**{
  "i" : 51,
})

u_2_2 = union2(**{
  "d" : 6.70000,
})

u_2_3 = union2(**{
  "s" : struct1(**{
    "a" : 8,
    "b" : "abacabb",
  }),
})

u_2_4 = union2(**{
  "u" : union1(**{
    "i" : 43,
  }),
})

u_2_5 = union2(**{
  "u" : union1(**{
    "d" : 9.80000,
  }),
})

u_2_6 = union2(**{
  "u" : union1(**{
  }),
})

apostrophe = "'"

tripleApostrophe = "'''"

quotationMark = "\""

backslash = "\\"

escaped_a = "a"

char2ascii = {
  "'" : 39,
  "\"" : 34,
  "\\" : 92,
  "a" : 97,
}

escaped_strings = [
  "\x01",
  "\x1f",
  " ",
  "'",
  "\"",
  """
""",
  "\x0d",
  "\x09",
  "a",
  "«",
  "j",
  "¦",
  "ayyy",
  "«yyy",
  "jyyy",
  "¦yyy",
  "zzza",
  "zzz«",
  "zzzj",
  "zzz¦",
  "zzzayyy",
  "zzz«yyy",
  "zzzjyyy",
  "zzz¦yyy",
]

false_c = False

true_c = True

zero_byte = 0

zero16 = 0

zero32 = 0

zero64 = 0

zero_dot_zero = 0.00000

empty_string = ""

empty_int_list = [
]

empty_string_list = [
]

empty_int_set = set([
])

empty_string_set = set([
])

empty_int_int_map = {
}

empty_int_string_map = {
}

empty_string_int_map = {
}

empty_string_string_map = {
}

maxIntDec = 9223372036854775807

maxIntOct = 9223372036854775807

maxIntHex = 9223372036854775807

maxIntBin = 9223372036854775807

maxDub = 1.79769e+308

minDub = 2.22507e-308

minSDub = 4.94066e-324

maxPIntDec = 9223372036854775807

maxPIntOct = 9223372036854775807

maxPIntHex = 9223372036854775807

maxPIntBin = 9223372036854775807

maxPDub = 1.79769e+308

minPDub = 2.22507e-308

minPSDub = 4.94066e-324

minIntDec = -9223372036854775808

minIntOct = -9223372036854775808

minIntHex = -9223372036854775808

minIntBin = -9223372036854775808

maxNDub = -1.79769e+308

minNDub = -2.22507e-308

minNSDub = -4.94066e-324

