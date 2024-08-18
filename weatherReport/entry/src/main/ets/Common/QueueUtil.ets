export default class Queue<T> {
  items: T[] = [];

  // 入队
  enqueue(item: T): void {
    this.items.push(item);
  }

  // 出队
  dequeue(): T | undefined {
    if (this.isEmpty()) {
      return undefined;
    }
    return this.items.shift();
  }

  // 查看队首元素
  front(): T | undefined {
    if (this.isEmpty()) {
      return undefined;
    }
    return this.items[0];
  }

  // 检查队列是否为空
  isEmpty(): boolean {
    return this.items.length === 0;
  }

  // 获取队列的大小
  size(): number {
    return this.items.length;
  }

  // 打印队列中的所有元素（辅助方法）
  print(): void {
    console.log(this.items.toString());
  }
}