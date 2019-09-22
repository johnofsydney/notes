# Javascript

## Exporting functions to other files


e.g. 1 - _module.exports_
```js
───────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────
function Gigasecond(date) {
  ...
}

module.exports = Gigasecond;

...

var Gigasecond = require('./gigasecond');
```

e.g. 2 - _export const <function> = function() {_
```js
export const steps = function(num) {
  ...
  return counter
}

...

import { steps } from './collatz-conjecture';

```


e.g. 3 -
```js
const Triangle = function (s1, s2, s3) {
  ...
}

export default Triangle

...

import Triangle from './triangle';

```
