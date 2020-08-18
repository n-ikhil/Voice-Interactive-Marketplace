var pos = require("pos");
var chunker = require("pos-chunker");

exports.extractingNouns = (rvstring) => {
  const words = new pos.Lexer().lex(rvstring);
  const tags = new pos.Tagger()
    .tag(words)
    .map((tag) => {
      return tag[0] + "/" + tag[1];
    })
    .join(" ");
  places = chunker.chunk(tags, "[{ tag: NNP }]");
  const noun_check = tags.split(" ");
  const final_nouns = [];
  noun_check.forEach((el) => {
    const wrds = el.split("/");
    const s1 = wrds[0];
    const s2 = wrds[1];
    if (s2.length >= 2 && s2[0] === "N" && s2[1] === "N") final_nouns.push(s1);
  });

  return final_nouns;
};
