import argparse
import pandas as pd
import os

css_path = "/home/yli/e/Dropbox/github/dotfiles/mango/waybar/"
template = "style_template.css"


def main():
    parser = argparse.ArgumentParser(description="Path to your color file")
    parser.add_argument("file", help="file path")
    args = parser.parse_args()

    path = args.file
    df = pd.read_csv(path, sep="|")
    names = df.name.to_list()
    color_map = df.set_index("name").to_dict()
    template_str = ""
    template_path = os.path.join(css_path, template)
    try:
        with open(template_path, "r") as f:
            template_str = f.read()
    except Exception as e:
        print("error", e)
    replaced = template_str
    for name in names:
        replaced = (
            replaced.replace(f"{{text_{name}}}", color_map["text"][name])
            .replace(f"{{bg_{name}}}", color_map["bg"][name])
            .replace(f"{{border_{name}}}", color_map["border"][name])
        )
    out_path = os.path.join(css_path, "style.css")
    try:
        with open(out_path, "w") as f:
            f.write(replaced)
    except Exception as e:
        print("error", e)


if __name__ == "__main__":
    main()
