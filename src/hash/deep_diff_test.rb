load 'deep_diff.rb'

# Example 1: Both hashes are empty
c = {}
d = {}
cc = {'Empty' => c}
dd = {'Empty' => d}
pp cc.deep_diff(c: dd)

# Example 2: One hash is empty, the other is not
e = {'Neko' => 'Nya'}
f = {}
ee = {'Empty' => e}
ff = {'Empty' => f}
pp ee.deep_diff(c: ff)

# Example 3: Both hashes have the same keys, but different values
g = {'Neko' => 'Nya', 'Inu' => 'Wan'}
h = {'Neko' => 'nya', 'Inu' => 'Wan'}
gg = {'SameKeys' => g}
hh = {'SameKeys' => h}
pp gg.deep_diff(c: hh)

# Example 4: Both hashes have different keys
i = {'Neko' => 'Nya', 'Inu' => 'Wan'}
j = {'Usagi' => 'Pyon', 'Tori' => 'Chun'}
ii = {'DiffKeys' => i}
jj = {'DiffKeys' => j}
pp ii.deep_diff(c: jj)
