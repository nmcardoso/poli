import argparse
import json
import re
from pathlib import Path

from pygments import highlight
from pygments.formatters import TerminalFormatter
from pygments.lexers import JsonLexer


def dict_print(d: dict):
  json_str = json.dumps(d, indent=4, sort_keys=True)
  print(highlight(json_str, JsonLexer(), TerminalFormatter()))


def main(path: str):
  regex = r'var H5PIntegration = ({.*});'
  p = Path(path)
  html = p.read_text()
  m = re.findall(regex, html, re.M)[0]
  obj = json.loads(m)
  k = list(obj['contents'].keys())[0]
  content_str = obj['contents'][k]['jsonContent']
  content_obj = json.loads(content_str)
  final = []
  for q in content_obj['questions']:
    params = q['params']
    if 'questions' in params:
      final.append({
        'ans': q['params']['questions'],
      })
    elif 'answers' in params:
      final.append({
        'ans': q['params']['answers'],
      })
      
  for i, question in enumerate(final):
    print(f'>> Question {i+1} of {len(final)}')
    dict_print(question['ans'])
    print()
  
  
if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.add_argument('file', action='store')
  args = parser.parse_args()
  main(args.file)
