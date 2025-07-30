file = '/home/natan/Downloads/199. Ar inicialmente a 100 kPa e 17 °C é comprimido até 700.html'

with open(file) as f:
  content = f.read()

content = content.replace('filter: blur(5px) !important;', '')
content = content.replace('filter: blur(5px) !important', '')

with open(file, 'w') as f:
  f.write(content)
