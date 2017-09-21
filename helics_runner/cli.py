import click
from ._version import __version__


@click.group()
@click.version_option(__version__, '--version')
def cli():
    pass


@click.command()
def setup():
    pass


@click.command()
def run():
    pass


if __name__ == "__main__":
    cli()
