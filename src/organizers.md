---
title: Organizers
...

<!-- TODO less padding around the bubbles -->
<!-- TODO move to CSS and unify with all pages -->
<!-- TODO and make this a template -->
<!-- TODO chair and co-chair should go at the top -->

<h2>2019 Organizing Committee</h2>

<div style="max-width: 90%;">
<ul class="personList">
$for(current)$
$partial("templates/person.html")$
$endfor$
</ul>
</div>

<h2>Past Committee Members</h2>

<div style="max-width: 90%;">
<ul class="personList">
$for(previous)$
$partial("templates/person.html")$
$endfor$
</ul>
</div>
