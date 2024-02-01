import nbformat
from nbconvert import HTMLExporter
from traitlets.config import Config

# Load the Jupyter Notebook file
notebook_filename = '/mnt/data/01_scCellFie_Metabolism.ipynb'

# Read the notebook
with open(notebook_filename, 'r', encoding='utf-8') as f:
    notebook_content = nbformat.read(f, as_version=4)

# Configure the HTMLExporter
c = Config()
c.TagRemovePreprocessor.enabled = True
c.TagRemovePreprocessor.remove_cell_tags = ('remove_cell',)
c.TagRemovePreprocessor.remove_input_tags = ('remove_input',)
c.TagRemovePreprocessor.remove_all_outputs_tags = ('remove_output',)
c.TagRemovePreprocessor.remove_single_output_tags = ('remove_single_output',)
c.HTMLExporter.preprocessors = ['nbconvert.preprocessors.TagRemovePreprocessor']

c.HTMLExporter.exclude_input = False
c.HTMLExporter.exclude_output_prompt = True
c.HTMLExporter.exclude_input_prompt = True

# Use custom template file
c.HTMLExporter.template_file = 'full'

# Create an HTML Exporter with custom configurations
html_exporter = HTMLExporter(config=c)

# Export the notebook to HTML
body, resources = html_exporter.from_notebook_node(notebook_content)

# Save the HTML to a file
html_filename = notebook_filename.replace('.ipynb', '_collapsed.html')
with open(html_filename, 'w', encoding='utf-8') as f:
    f.write(body)

html_filename


