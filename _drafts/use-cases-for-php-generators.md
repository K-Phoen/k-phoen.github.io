---
layout: post
title: Use cases for PHP generators
---

When I go to local user groups, conferences or when I just talk with other PHP
developers, I'm often asked if I use PHP generators and when.

Despite being available since PHP 5.5.0, generators are still largely underused.
In fact, it appears than most of the developers I know understand how generators
work but don't seem to see when they could be useful in *real-world* cases.

> Yeah, generators definitely look great but you know… except for computing the
> Fibonacci sequence, I don't see how it could be useful to me.

And they're not wrong, even the examples in PHP's documentation about generators
are pretty simplistic. They only show how to [efficiently implement `range`](http://php.net/manual/en/language.generators.overview.php)
or [iterate over the lines of a file](http://php.net/manual/en/language.generators.comparison.php).

But hey, even from these simple examples we can understand the core aspects of
generators: they are *just* simplified `Iterator`s.

> A generator allows you to write code that uses `foreach` to iterate over a set
> of data without needing to build an array in memory

As a PHP developer, I often need to iterate through large data-sets and memory
usage definitely is one of my main concerns.

## Iterating through large data-sets

## Aggregating several data-sources

## Complex, on-demand hydration for database rows

## Simulating async tasks
