from pathlib import Path
import os


def main():
  project_path = Path(__file__).parent

  for file in project_path.glob('*.vwf'):
    with file.open('r') as fp:
      file_content = fp.read()
    
    new_content = file_content.replace(
      '/home/natan/repos/poli/lab-digital/p2/relogio/', 
      str(project_path.absolute()) + os.sep
    )

    with file.open('w') as fp:
      fp.write(new_content)

  print('Arquivos atualizados')


if __name__ == '__main__':
  main()
