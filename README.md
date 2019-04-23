> This project has two homes.
> It is ok to work in github, still, for a better decentralized web
> please consider contributing (issues, PR, etc...) throught:
>
> https://gitlab.esy.fun/yogsototh/parsec-presentation

---


This is just my personal branch for [deck.js](http://imakewebthings.github.com/deck.js) presentation.

It doesn't need an Internet connexion to work.
All js and fonts are copied locally.


I added:

- [solarized](http://ethanschoonover.com/solarized) color scheme
- [highlight.js](softwaremaniacs.org/soft/highlight/en) for code highlighting
- [MathJax](www.mathjax.org) for displaying math

Bonus:

- An optional ad hock generation tool to organize slides in subdirectories.
- An optional [metapost](www.tug.org/metapost.html) generator with my own graph drawing library to create perfect images.

Also use:

- [deck.js](http://imakewebthings.github.com/deck.js) of course!
- [jQuery](http://jquery.com)
- [Modernizr](http://modernizr.com)

## How to use?

~~~
> cp -r example my-project-name
~~~

Create files and directories:

~~~
10_Introduction/
  010_.html
  020_Plan.md
  030_First_part.md
20_Second_Part/
  010_Plan.md
  020_Another_title.md
30_Third_Part/
  010_Plan.md
  020_Third_title.md
  030_Conclusion.md
~~~

~~~
> ./my-project-name/gen
~~~

If you use metapost

~~~
> cd my-project-name/img/mp
> ./gen
~~~
