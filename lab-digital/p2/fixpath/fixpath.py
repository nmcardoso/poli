from pathlib import Path
import os
import re

PATH_TO_REPLACE = '/home/natan/repos/poli/lab-digital/p2/relogio'
PROJECT_PATH = Path(__file__).parent
PATTERNS = [
  '--vector_source=\"(.*?)\"',
  '--testbench_file=\"(.*?)\"',
  '--output_directory=\"(.*?)\"'
]

flatten = lambda xss: [x for xs in xss for x in xs]

def main():
  for file in PROJECT_PATH.glob('*.vwf'):
    with file.open('r') as fp:
      file_content = fp.read()
    
    matches = flatten([re.findall(p, file_content) for p in PATTERNS])

    targets = [
      m.replace(
        PATH_TO_REPLACE, 
        str(PROJECT_PATH.absolute())
      ).replace('/', os.sep) 
      for m in matches
    ]

    new_content = file_content
    for source, target in zip(matches, targets):
      new_content = new_content.replace(source, target) 

    with file.open('w') as fp:
      fp.write(new_content)

  print('Arquivos atualizados')


if __name__ == '__main__':
  main()
