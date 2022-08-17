from kittens.tui.handler import result_handler


def main():
    pass

@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss):
    direction = args[1]
    boss.active_tab.neighboring_window(direction)
