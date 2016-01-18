---
layout: post
title: Use cases for PHP generators
---

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

Let's assume that I have a large collection of e-books and that I want to
filter those which can be read in a web-reader.

Traditionally, I would write something like this:

```php
private function getEbooksEligibleToWebReader($ebooks)
{
    $rule = 'format = "EPUB" AND protection != "Adobe DRM"';
    $filteredEbooks = [];

    foreach ($ebooks as $ebook) {
        if ($this->rulerz->satisfies($ebook, $rule)) {
            $filteredEbooks[] = $ebook;
        }
    }

    return $filteredEbooks;
}
```

The problem here is easy to see: the more free e-books I have, the more
`$filteredEbooks` will consume memory.

A solution could be to create an iterator that would iterate through the
`$ebooks` and return on-demand the ones that are eligible. But we would have to
create a new class just for that and iterators are a bit tedious to write… Lucky
us, since PHP 5.5.0 we can use generators!

```php
private function getEbooksEligibleToWebReader($ebooks)
{
    $rule = 'format = "EPUB" AND protection != "Adobe DRM"';

    foreach ($ebooks as $ebook) {
        if ($this->rulerz->satisfies($ebook, $rule)) {
            yield $ebook;
        }
    }
}
```

Yep, refactoring the `getEbooksEligibleToWebReader` method to use generators is
as simple as replacing the assignation to `$filteredEbooks` by a `yield`
statement.

The memory consumption will now be stable, no matter the number of eligible
books and we are sure to find these books only if and when we need them.

**Bonus**: [RulerZ](https://github.com/K-Phoen/rulerz) internally uses generators
so we could rewrite the method like this and be as efficient in terms of memory.

```php
private function getEbooksEligibleToWebReader($ebooks)
{
    $rule = 'format = "EPUB" AND protection != "Adobe DRM"';

    return $this->rulerz->filter($ebooks, $rule)) {
}
```

## Aggregating several data-sources

Now, let's consider the `$ebook` retrieval part. I didn't tell you, but these
ebooks come in fact from different data-sources: a database and a file.

We can then write a simple method to aggregate these two sources:

```php
private function getEbooks()
{
    $ebooks = [];

    // fetch from the DB
    $stmt = $this->db->prepare("SELECT * FROM ebook_catalog");
    $stmt->execute();
    $stmt->setFetchMode(\PDO::FETCH_ASSOC);

    foreach ($stmt as $data) {
        $ebooks[] = $data;
    }

    // and also from a CSV file
    $file = new SplFileObject($this->getBooksCsvFilename());
    $file->setFlags(SplFileObject::READ_CSV | SplFileObject::READ_AHEAD | SplFileObject::SKIP_EMPTY | SplFileObject::DROP_NEW_LINE);

    while (!$file->eof()) {
        $ebooks[] = $file->fgetcsv();
    }

    return $ebooks;
}
```

But once again, the amount of memory used by this method depends too much on the
number of e-books we have in the database and in the CSV file.

We could start by using generators to return the results:

```php
private function getEbooks()
{
    // fetch from the DB
    $stmt = $this->db->prepare("SELECT * FROM ebook_catalog");
    $stmt->execute();
    $stmt->setFetchMode(\PDO::FETCH_ASSOC);

    foreach ($stmt as $data) {
        yield $data;
    }

    // and also from a CSV file
    $file = new SplFileObject($this->getBooksCsvFilename());
    $file->setFlags(SplFileObject::READ_CSV | SplFileObject::READ_AHEAD | SplFileObject::SKIP_EMPTY | SplFileObject::DROP_NEW_LINE);

    while (!$file->eof()) {
        yield $file->fgetcsv();
    }
}
```

That's better, but we still have a problem: our `getBooks` method does too much
work! We should split the two responsibilities (reading in the database and
reading the CSV file) in two separate methods:

```php
private function getEbooks()
{
    yield from $this->getEbooksFromDatabase();
    yield from $this->getEbooksFromCSV();
}

private function getEbooksFromDatabase()
{
    // fetch from the DB
    $stmt = $this->db->prepare("SELECT * FROM ebook_catalog");
    $stmt->execute();
    $stmt->setFetchMode(\PDO::FETCH_ASSOC);

    foreach ($stmt as $data) {
        yield $data;
    }
}

private function getEbooksFromCSV()
{
    // and also from a CSV file
    $file = new SplFileObject($this->getBooksCsvFilename());
    $file->setFlags(SplFileObject::READ_CSV | SplFileObject::READ_AHEAD | SplFileObject::SKIP_EMPTY | SplFileObject::DROP_NEW_LINE);

    while (!$file->eof()) {
        yield $file->fgetcsv();
    }
}
```

You will notice the use of the `yield from` operator (available since PHP 7.0)
that allows to delegate the use of generators. That's perfect, for instance, to
aggregate several data-sources that use generators.

## Complex, on-demand hydration for database rows

## Simulating async tasks
