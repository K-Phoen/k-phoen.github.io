---
layout: post
title: RulerZ, specifications and Symfony are in a boat
---

In [my previous article](http://blog.kevingomez.fr/2015/02/07/on-taming-repository-classes-in-doctrine-among-other-things/), I tried to answer the following question: **how do you keep your Doctrine repositories from growing exponentially**?
Long story short, I came up with a generic solution based on the [Specification pattern](http://en.wikipedia.org/wiki/Specification_pattern) that essentially **abstracts and simplifies** the way we write and compose **queries**. And the best part is that it works with Doctrine but also with any other datasource.

**[RulerZ](https://github.com/K-Phoen/rulerz) was born**.

Of course, there was a real need behind my previous question. For one of my current projects, I wanted to be able to switch from one datasource to another. My application would use Doctrine in development and production environment but for tests I wanted my data to live in memory.

First thing first, I needed to be able to **manipulate** my **data**.

To achieve that, I defined a <code>CompanyRepository</code> interface — it's a small project that mainly deals with *companies* — and wrote two classes implementing it: one using Doctrine and another one storing my objects in memory.

In the beginning, I only needed to save a company and retrieve it by it's slug so both implementations were simple and it all worked as expected. The real issue came when I started to implement a search engine. For each new search criteria, I had to update two classes and implement the same criteria twice.

At this point, my repositories looked like this :

<script src="https://gist.github.com/K-Phoen/5c1b06a864d063c1ee4e.js?file=old_repositories.php"></script>

The first issue is that my <code>CompanyRepository::search(array $criteria)</code> method violates the [open/closed principle](http://en.wikipedia.org/wiki/Open/closed_principle). This is solved by replacing the <code>$criteria</code> parameter by [specifications](http://en.wikipedia.org/wiki/Specification_pattern). Each specification representing a single search criteria.

The second issue is that with *"classic"* specifications, the same specification can't be used to filter data from several datasources. We saw that with RulerZ, this [problem is solved](http://blog.kevingomez.fr/2015/02/07/on-taming-repository-classes-in-doctrine-among-other-things/).

**Using RulerZ**, the two previous repositories can be refactored:

<script src="https://gist.github.com/K-Phoen/5c1b06a864d063c1ee4e.js?file=new_repositories.php"></script>

You probably noticed a <small>not so</small> subtle difference compared to the old repositories: I rely on RulerZ so I have to inject it somehow. Lucky me, I'm working on a Symfony application and there is [a bundle for that](https://github.com/K-Phoen/RulerZBundle)!

As **RulerZ** is now properly **integrated into my repositories** and I'm able to query my data, I need to address the **specification-creation issue**.
Remember, I was trying to implement a search engine so **how do I map a search** as expressed by a user (through a form for instance) **to a specification**?

The idea here is to map a user input — a search criteria — to a specification. A string (or a scalar) to an object. Using Symfony Form component. Looks a lot like a **[DataTransformer](http://symfony.com/doc/current/cookbook/form/data_transformers.html)** don't you think?

With that in mind, I wrote the following form type:

<script src="https://gist.github.com/K-Phoen/5c1b06a864d063c1ee4e.js?file=search_form_type.php"></script>

The form type itself is pretty straightforward, the only thing to notice is the usage of <code>SpecToStringTransformer</code>. It takes two parameters: the <abbr title="Fully-Qualified Class Name">FQCN</abbr> of the specification to build and a property in this specification containing the value.
The transformer's code itself isn't really important but if you really want to read it, it's available as [a gist](https://gist.github.com/K-Phoen/5c1b06a864d063c1ee4e#file-data_transformer-php).

What's important is that combining the Form Component, a simple transformer and RulerZ leads to really simple controllers:

<script src="https://gist.github.com/K-Phoen/5c1b06a864d063c1ee4e.js?file=search_controller.php"></script>

Do you see the magic? A classic **form type** can automatically **build specifications** that can be used to **retrieve data** from a Doctrine repository, an in-memory repository or virtually any other datasource.
Also, adding new search criteria boils down to writing its specification and adding a new field in the form type. How cool is that?
