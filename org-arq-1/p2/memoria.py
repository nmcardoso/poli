from dataclasses import dataclass


@dataclass
class TableLine:
  ref = None
  index = None
  tag = None
  hit = None
  miss_type = None
  

def print_table(table):
  for l in table:
    print('Ref:', f'{l.ref:03d}', '\tIndex:', l.index, '\tTag:', l.tag, f'({int(l.tag, 2)})', '\tHit:', l.hit, '\tTipo:', l.miss_type)
    

def main():
  WORD_SIZE = 32 # size in bits
  offset_size = 1 # size in bits log2(# de palavras)
  index_size = 2 # size in bits log2(# de blocos)
  addresses = [1, 4, 8, 5, 20, 17, 19, 56, 9, 12, 4, 44]
  
  table = []
  cache = {}
  for addr in addresses:
    addr_bin = format(addr, '032b')
    index_bits = addr_bin[WORD_SIZE - (index_size + offset_size) : WORD_SIZE - offset_size]
    tag_bits = addr_bin[0 : WORD_SIZE - (index_size + offset_size)]
    
    t = TableLine()
    t.ref = addr
    t.index = index_bits
    t.tag = tag_bits
    index = int(index_bits, 2)
    tag = int(tag_bits, 2)
    
    if index in cache:
      if cache[index] == tag:
        t.hit = 'hit'
        t.miss_type = '-'
      else:
        t.hit = 'miss'
        t.miss_type = 'Conflito'
        cache[index] = tag
    else:
      t.hit = 'miss'
      t.miss_type = 'Compulsória'
      cache[index] = tag
    
    table.append(t)
  
  print_table(table)
  


if __name__ == '__main__':
  main()
