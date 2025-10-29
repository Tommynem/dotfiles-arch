local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

return {
	-- HTML5 Boilerplate
	s("html5", {
		t({
			"<!DOCTYPE html>",
			'<html lang="en">',
			"<head>",
			'    <meta charset="UTF-8">',
			'    <meta name="viewport" content="width=device-width, initial-scale=1.0">',
			"    <title>",
		}),
		i(1, "Document"),
		t({
			"</title>",
			"</head>",
			"<body>",
			"    ",
		}),
		i(2),
		t({
			"",
			"</body>",
			"</html>",
		}),
	}),

	-- Basic HTML structure
	s("!", {
		t({
			"<!DOCTYPE html>",
			'<html lang="en">',
			"<head>",
			'    <meta charset="UTF-8">',
			'    <meta name="viewport" content="width=device-width, initial-scale=1.0">',
			"    <title>",
		}),
		i(1, "Document"),
		t({
			"</title>",
			"</head>",
			"<body>",
			"    ",
		}),
		i(0),
		t({
			"",
			"</body>",
			"</html>",
		}),
	}),

	-- Div with class
	s("div", fmt("<div class='{}'>\n    {}\n</div>", { i(1), i(2) })),

	-- Div with id
	s("divi", fmt('<div id="{}">\n    {}\n</div>', { i(1), i(2) })),

	-- Section
	s("section", fmt("<section>\n    {}\n</section>", { i(1) })),

	-- Article
	s("article", fmt("<article>\n    {}\n</article>", { i(1) })),

	-- Header
	s("header", fmt("<header>\n    {}\n</header>", { i(1) })),

	-- Footer
	s("footer", fmt("<footer>\n    {}\n</footer>", { i(1) })),

	-- Nav
	s("nav", fmt("<nav>\n    {}\n</nav>", { i(1) })),

	-- Main
	s("main", fmt("<main>\n    {}\n</main>", { i(1) })),

	-- Aside
	s("aside", fmt("<aside>\n    {}\n</aside>", { i(1) })),

	-- Paragraph
	s("p", fmt("<p>{}</p>", { i(1) })),

	-- Headings
	s("h1", fmt("<h1>{}</h1>", { i(1) })),
	s("h2", fmt("<h2>{}</h2>", { i(1) })),
	s("h3", fmt("<h3>{}</h3>", { i(1) })),
	s("h4", fmt("<h4>{}</h4>", { i(1) })),
	s("h5", fmt("<h5>{}</h5>", { i(1) })),
	s("h6", fmt("<h6>{}</h6>", { i(1) })),

	-- Link
	s("a", fmt('<a href="{}">{}</a>', { i(1), i(2, "link text") })),

	-- Image
	s("img", fmt('<img src="{}" alt="{}"{}>', { i(1), i(2), i(3) })),

	-- Figure with image and caption
	s("figure", {
		t({ "<figure>", '    <img src="' }),
		i(1),
		t('" alt="'),
		i(2),
		t({ '">', "    <figcaption>" }),
		i(3),
		t({ "</figcaption>", "</figure>" }),
	}),

	-- Unordered list
	s("ul", {
		t({ "<ul>", "    <li>" }),
		i(1),
		t({ "</li>", "</ul>" }),
	}),

	-- Ordered list
	s("ol", {
		t({ "<ol>", "    <li>" }),
		i(1),
		t({ "</li>", "</ol>" }),
	}),

	-- List item
	s("li", fmt("<li>{}</li>", { i(1) })),

	-- Button
	s("button", fmt('<button type="{}">{}</button>', { c(1, { t("button"), t("submit"), t("reset") }), i(2) })),

	-- Form
	s("form", {
		t('<form action="'),
		i(1),
		t('" method="'),
		c(2, { t("post"), t("get") }),
		t({ '">', "    " }),
		i(3),
		t({ "", "</form>" }),
	}),

	-- Input
	s(
		"input",
		fmt('<input type="{}" name="{}" id="{}"{}>', {
			c(1, {
				t("text"),
				t("email"),
				t("password"),
				t("number"),
				t("tel"),
				t("url"),
				t("date"),
				t("checkbox"),
				t("radio"),
				t("file"),
				t("hidden"),
				t("submit"),
				t("reset"),
			}),
			i(2),
			rep(2),
			i(3),
		})
	),

	-- Label
	s("label", fmt('<label for="{}">{}</label>', { i(1), i(2) })),

	-- Textarea
	s("textarea", fmt('<textarea name="{}" id="{}" rows="{}" cols="{}">{}</textarea>', { i(1), rep(1), i(2, "5"), i(3, "30"), i(4) })),

	-- Select with options
	s("select", {
		t('<select name="'),
		i(1),
		t('" id="'),
		rep(1),
		t({ '">', '    <option value="' }),
		i(2),
		t('">'),
		i(3),
		t({ "</option>", "</select>" }),
	}),

	-- Table
	s("table", {
		t({ "<table>", "    <thead>", "        <tr>", "            <th>" }),
		i(1),
		t({ "</th>", "        </tr>", "    </thead>", "    <tbody>", "        <tr>", "            <td>" }),
		i(2),
		t({ "</td>", "        </tr>", "    </tbody>", "</table>" }),
	}),

	-- Script tag
	s("script", fmt('<script src="{}"></script>', { i(1) })),

	-- Inline script
	s("scripts", {
		t({ "<script>", "    " }),
		i(1),
		t({ "", "</script>" }),
	}),

	-- Link CSS
	s("link", fmt('<link rel="stylesheet" href="{}">', { i(1) })),

	-- Style tag
	s("style", {
		t({ "<style>", "    " }),
		i(1),
		t({ "", "</style>" }),
	}),

	-- Meta tags
	s("meta", fmt('<meta name="{}" content="{}">', { i(1), i(2) })),
	s("metac", fmt('<meta charset="{}">', { i(1, "UTF-8") })),
	s("metav", t('<meta name="viewport" content="width=device-width, initial-scale=1.0">')),

	-- Video tag
	s("video", {
		t('<video width="'),
		i(1, "320"),
		t('" height="'),
		i(2, "240"),
		t('" controls>'),
		t({ "", '    <source src="' }),
		i(3),
		t('" type="'),
		i(4, "video/mp4"),
		t({ '">', "    Your browser does not support the video tag.", "</video>" }),
	}),

	-- Audio tag
	s("audio", {
		t({ "<audio controls>", '    <source src="' }),
		i(1),
		t('" type="'),
		i(2, "audio/mpeg"),
		t({ '">', "    Your browser does not support the audio element.", "</audio>" }),
	}),

	-- Canvas
	s("canvas", fmt('<canvas id="{}" width="{}" height="{}"></canvas>', { i(1), i(2, "300"), i(3, "150") })),

	-- Comment
	s("c", fmt("<!-- {} -->", { i(1) })),

	-- Container div (common pattern)
	s("container", {
		t({ '<div class="container">', "    " }),
		i(1),
		t({ "", "</div>" }),
	}),

	-- Grid/Flex containers
	s("grid", {
		t({ '<div class="grid">', "    " }),
		i(1),
		t({ "", "</div>" }),
	}),

	s("flex", {
		t({ '<div class="flex">', "    " }),
		i(1),
		t({ "", "</div>" }),
	}),

	-- Card component (common pattern)
	s("card", {
		t({ '<div class="card">', '    <div class="card-header">', "        " }),
		i(1, "Header"),
		t({ "", "    </div>", '    <div class="card-body">', "        " }),
		i(2, "Content"),
		t({ "", "    </div>", '    <div class="card-footer">', "        " }),
		i(3, "Footer"),
		t({ "", "    </div>", "</div>" }),
	}),

	-- Modal (common pattern)
	s("modal", {
		t({ '<div class="modal" id="' }),
		i(1, "myModal"),
		t({ '">', '    <div class="modal-content">', '        <div class="modal-header">', '            <span class="close">&times;</span>', "            <h2>" }),
		i(2, "Modal Header"),
		t({ "</h2>", "        </div>", '        <div class="modal-body">', "            " }),
		i(3, "Modal content..."),
		t({ "", "        </div>", '        <div class="modal-footer">', "            " }),
		i(4, "Footer content..."),
		t({ "", "        </div>", "    </div>", "</div>" }),
	}),
}